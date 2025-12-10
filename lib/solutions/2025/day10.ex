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

  def part_two(machines) do
    machines
    |> Enum.with_index(1)
    # |> :lists.reverse()
    |> Enum.sum_by(fn {machine, index} -> joltage_press(machine, index) end)
  end

  defp joltage_press({_, buttons, target}, machine_index) do
    size = length(target)
    buttons |> dbg()
    target |> dbg()
    min_press = Enum.max(target)
    init_state = {Map.new(buttons, &button_to_incrementors(&1, target)), 0} |> dbg()
    loop(_states = [init_state], target, min_press, 1, machine_index)
  catch
    {:found, n} -> n
  end

  defp button_to_incrementors(indices, target) do
    increments = for(i <- 0..(length(target) - 1), do: if(i in indices, do: 1, else: 0))

    # the minimum value that is touched by this button becomes the max allowed presses
    target |> dbg()

    max_press =
      indices
      |> Enum.map(&Enum.at(target, &1))
      |> Enum.min()

    {increments, {max_press, _pressed = 0}}
  end

  defp loop([], _, _, _, _) do
    raise "no more states"
  end

  defp loop(states, target, min_press, iter, machine_index) do
    IO.puts("-- #{machine_index} / #{iter} -----------------------")
    states = Enum.flat_map(states, &press_to_new_states(&1, target, min_press))
    # IO.puts("length before uniq: #{length(states)}")
    states = Enum.uniq(states)
    IO.puts("length after uniq: #{length(states)}")
    # states = Enum.take(Enum.sort_by(states, &heuristic(&1, target)), 30_000)
    # IO.puts("length after heuristic: #{length(states)}")
    loop(states, target, min_press, iter + 1, machine_index)
  end

  # returns all next states for a state, one for each pressable button
  defp press_to_new_states(state, target, min_press) do
    {buttons, total_press} = state

    Enum.flat_map(buttons, fn
      # maxed out
      {button, {max_press, max_press}} ->
        []

      {button, {max_press, pressed}} ->
        new_state = {Map.put(buttons, button, {max_press, pressed + 1}), total_press + 1}

        case classify(new_state, target, min_press) do
          :overshoot -> []
          :too_low -> [new_state]
          :equal -> throw({:found, total_press + 1})
        end
    end)
  end

  defp classify({map, n} = state, target, min_press) when n < min_press do
    vals = state_value(state)
    comparison = Enum.zip(vals, target)

    if Enum.any?(comparison, fn {v, t} -> v > t end) do
      :overshoot
    else
      :too_low
    end
  end

  defp classify(state, target, min_press) do
    vals = state_value(state)

    if vals == target do
      :equal
    else
      comparison = Enum.zip(vals, target)

      if Enum.any?(comparison, fn {v, t} -> v > t end) do
        :overshoot
      else
        :too_low
      end
    end
  end

  defp heuristic(state, target) do
    Enum.zip_with([target, state_value(state)], fn [t, v] ->
      t / (t - v + 1)
    end)
    |> Enum.sum()
  end

  defp state_value({map, _}) do
    map
    |> Enum.map(fn {buttons, {_, presses}} -> Enum.map(buttons, &(&1 * presses)) end)
    |> Enum.zip_with(&Enum.sum/1)
  end
end
