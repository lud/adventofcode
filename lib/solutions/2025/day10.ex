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
      |> Enum.sort()

    jolts =
      jolts
      |> String.trim_trailing("}")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> dbg()

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

  def part_two(problem) do
    problem
  end
end
