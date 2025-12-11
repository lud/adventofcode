defmodule AdventOfCode.Solutions.Y25.Day10 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    "[" <> rest = line
    [lights, " (" <> rest] = String.split(rest, "]")

    lights =
      lights
      |> String.to_charlist()
      |> :lists.reverse()
      |> Enum.map(fn
        ?. -> 0
        ?# -> 1
      end)

    [prev, jolts] = String.split(rest, ") {")
    buttons = String.split(prev, ") (")

    buttons =
      Enum.map(buttons, fn str ->
        str |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)

    jolts =
      jolts
      |> String.trim_trailing("}")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {lights, buttons, jolts}
  end

  def part_one(machines) do
    machines
    |> Enum.map(fn {lights, buttons, _} ->
      lights = Integer.undigits(lights, 2)
      buttons = Enum.map(buttons, &button_to_int/1)
      {lights, buttons}
    end)
    |> Enum.sum_by(&best_combination/1)
  end

  defp button_to_int(indexes) do
    Enum.reduce(indexes, 0, &(2 ** &1 + &2))
  end

  defp best_combination(machine) do
    {lights, buttons} = machine

    stream_buttons(buttons)
    |> Enum.find_value(fn pressed_buttons ->
      if lights == Enum.reduce(pressed_buttons, 0, &Bitwise.bxor(&1, &2)) do
        length(pressed_buttons)
      else
        nil
      end
    end)
  end

  defp stream_buttons(buttons) do
    n_presses = Stream.iterate(1, &(&1 + 1))

    Stream.flat_map(n_presses, fn n ->
      stream_buttons(n, buttons)
    end)
  end

  # TODO we are repeating: [0, 1] and [1, 0] should be the same XOR result, we
  # should just iterate on digits, right ? But we still need to return [0, 0]
  # somehow

  defp stream_buttons(1, buttons) do
    Enum.map(buttons, &[&1])
  end

  defp stream_buttons(n, buttons) when n > 0 do
    stream_buttons(n - 1, buttons)
    |> Stream.flat_map(fn [top | _] = pressed_buttons ->
      # Basic iteration
      # Stream.map(buttons, fn btn -> [btn | pressed_buttons] end)

      # Only try each combination once
      Stream.flat_map(buttons, fn
        btn when btn >= top -> [[btn | pressed_buttons]]
        _ -> []
      end)
    end)
  end

  def part_two(machines) do
    machines
    |> Task.async_stream(&solve_machine/1, max_concurrency: 200, ordered: false)
    |> Enum.sum_by(&elem(&1, 1))
  end

  defp solve_machine(machine) do
    {_, buttons, target} = machine

    args = Enum.take([:a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, :m], length(buttons))

    counter_dependencies =
      target
      |> Enum.with_index()
      |> Enum.map(fn {_, counter_index} ->
        buttons
        |> Enum.zip(args)
        |> Enum.filter(fn {button, _arg} ->
          counter_index in button
        end)
        |> Enum.map(fn {_button, arg} -> arg end)
      end)

    smt2 =
      [
        Enum.map(args, fn arg -> "(declare-const #{arg} Int)" end),
        Enum.map(args, fn arg -> "(assert (>= #{arg} 0))" end),
        Enum.zip_with(target, counter_dependencies, fn t, deps ->
          "(assert (= #{t} (+#{Enum.map(deps, &" #{&1}")})))"
        end),
        """
        (define-fun sum () Int (+#{Enum.map(args, &" #{&1}")}))
        (minimize sum)
        (check-sat)
        (get-value (sum))
        """
      ]

    z3 = System.find_executable("z3")
    port = Port.open({:spawn_executable, z3}, [:binary, args: ["-in"]])
    send(port, {self(), {:command, smt2}})

    int = receive_result(port)
    true = Port.close(port)
    int
  end

  defp receive_result(port) do
    receive do
      {^port, {:data, "sat\n"}} -> receive_result(port)
      {^port, {:data, "((sum " <> result}} -> parse_result(result)
      {^port, {:data, "sat\n((sum " <> result}} -> parse_result(result)
    end
  end

  defp parse_result(result) do
    {int, "))" <> _} = Integer.parse(result)
    int
  end
end
