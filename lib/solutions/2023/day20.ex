defmodule AdventOfCode.Y23.Day20 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    {modules, out_from} = Enum.map_reduce(input, _out_from = %{}, &parse_line/2)

    # now for each inverter we need to initialize state will all its possible inputs
    modules
    |> Enum.map(fn
      {key, {:conj, :uninitialized, outs}} ->
        state = Map.new(Map.fetch!(out_from, key), fn k -> {k, :low} end)
        {key, {:conj, state, outs}}

      other ->
        other
    end)
    |> Map.new()
  end

  defp parse_line(line, out_from) do
    [name, outs] = String.split(line, " -> ")

    {name, kind, state} =
      case name do
        "broadcaster" -> {"broadcaster", :bcast, nil}
        "%" <> name -> {name, :flip, :off}
        "&" <> name -> {name, :conj, :uninitialized}
      end

    outs = String.split(outs, ", ")
    out_from = Enum.reduce(outs, out_from, fn out, acc -> Map.update(acc, out, [name], &[name | &1]) end)

    module = {name, {kind, state, outs}}
    {module, out_from}
  end

  def part_one(modules) do
    {count_low, count_high, _} =
      Enum.reduce(1..1000, {0, 0, modules}, fn i, {count_low, count_high, modules} ->
        IO.puts("--- #{i} ---")
        {count_low_add, count_high_add, modules} = push_button(modules)
        {count_low + count_low_add, count_high + count_high_add, modules}
      end)

    count_low * count_high
  end

  # def part_two(problem) do
  #   problem
  # end

  defp push_button(modules) do
    init_pulse = {"button", :low, "broadcaster"}
    {count_low, count_high, modules} = reduce([init_pulse], modules, 0, 0)
  end

  defp reduce([], modules, count_low, count_high) do
    {count_low, count_high, modules}
  end

  defp reduce(pulses, modules, count_low, count_high) do
    {count_low, count_high} = count_pulses(pulses, count_low, count_high)

    {new_pulses, new_modules} =
      Enum.flat_map_reduce(pulses, modules, fn {_, kind, to} = p, modules ->
        case Map.fetch(modules, to) do
          {:ok, module} ->
            {next_pulses, new_module} = handle_pulse(p, module)
            modules = Map.put(modules, to, new_module)
            {next_pulses, modules}

          :error ->
            {[], modules}
        end
      end)

    reduce(new_pulses, new_modules, count_low, count_high)
  end

  defp handle_pulse({_, kind, me}, {:bcast, _, outs} = this) do
    # There is a single broadcast module (named broadcaster). When it receives a
    # pulse, it sends the same pulse to all of its destination modules.
    sends = send_all(outs, me, kind)
    {sends, this}
  end

  defp handle_pulse({_, :low, me}, {:flip, state, outs}) do
    # if a flip-flop module receives a low pulse, it flips between on and off.
    # If it was off, it turns on and sends a high pulse. If it was on, it turns
    # off and sends a low pulse.
    {new_state, send_kind} =
      case state do
        :off -> {:on, :high}
        :on -> {:off, :low}
      end

    sends = send_all(outs, me, send_kind)
    this = {:flip, new_state, outs}
    {sends, this}
  end

  defp handle_pulse({_, :high, _}, {:flip, _, _} = this) do
    # If a flip-flop module receives a high pulse, it is ignored and nothing
    # happens.
    {[], this}
  end

  defp handle_pulse({from, kind, me}, {:conj, state, outs}) do
    # Conjunction modules (prefix &) remember the type of the most recent pulse
    # received from each of their connected input modules; they initially
    # default to remembering a low pulse for each input. When a pulse is
    # received, the conjunction module first updates its memory for that input.
    # Then, if it remembers high pulses for all inputs, it sends a low pulse;
    # otherwise, it sends a high pulse.

    state = Map.replace!(state, from, kind)
    send_kind = if all_high?(state), do: :low, else: :high
    sends = send_all(outs, me, send_kind)
    this = {:conj, state, outs}
    {sends, this}
  end

  defp all_high?(map) do
    Enum.all?(map, fn
      {_, :high} -> true
      _ -> false
    end)
  end

  defp send_all(outs, me, kind) do
    Enum.map(outs, &{me, kind, &1})
  end

  defp count_pulses([{from, :low, to} = p | pulses], count_low, count_high) do
    print_pulse(p)
    count_pulses(pulses, count_low + 1, count_high)
  end

  defp count_pulses([{from, :high, to} = p | pulses], count_low, count_high) do
    print_pulse(p)
    count_pulses(pulses, count_low, count_high + 1)
  end

  defp count_pulses([], count_low, count_high) do
    {count_low, count_high}
  end

  defp print_pulse({from, kind, to} = p) do
    IO.puts("#{from} -#{kind}-> #{to}")
    p
  end
end
