defmodule AdventOfCode.Solutions.Y20.Day08 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Input.with_index_first()
    |> Enum.map(fn {i, v} -> {i, parse_line(v)} end)
  end

  defp parse_line(line) do
    [op, arg] = String.split(line, " ", parts: 2)
    {arg, ""} = Integer.parse(arg)
    {op, arg}
  end

  def part_one(problem) do
    problem
    |> load_state
    |> run_til_repeat
    |> case do
      {:infinite_loop, %{acc: acc}} -> acc
    end
  end

  def part_two(problem) do
    indexes = find_indexes(problem, ["jmp", "nop"])

    Enum.reduce(indexes, {:infinite_loop, nil}, fn
      index, {:infinite_loop, _} ->
        problem = swap_opcode(load_state(problem), index)
        run_til_repeat(problem)

      _, {:end_of_input, state} ->
        {:end_of_input, state}
    end)
    |> case do
      {:end_of_input, state} -> state.acc
    end
  end

  defp swap_opcode(%{ops: ops} = state, index) do
    ops =
      Map.update!(ops, index, fn
        {"jmp", v} -> {"nop", v}
        {"nop", v} -> {"jmp", v}
      end)

    %{state | ops: ops}
  end

  defp find_indexes(problem, opcodes) do
    problem
    |> Enum.filter(fn {_, {opcode, _}} -> opcode in opcodes end)
    |> Enum.map(&elem(&1, 0))
  end

  defp load_state(ops) do
    ops = Map.new(ops)
    %{pos: 0, ops: ops, ran: %{}, acc: 0}
  end

  def run_til_repeat(%{pos: pos, ran: ran} = state) do
    case ran[pos] do
      true -> {:infinite_loop, state}
      nil -> run_til_repeat(run_once(state))
    end
  end

  def run_til_repeat({:end_of_input, state}) do
    {:end_of_input, state}
  end

  def run_once(%{pos: pos, ops: ops, ran: ran, acc: acc} = state) do
    case Map.get(ops, pos, :end_of_input) do
      {"nop", _} -> %{state | ran: Map.put(ran, pos, true), pos: pos + 1}
      {"acc", v} -> %{state | ran: Map.put(ran, pos, true), pos: pos + 1, acc: acc + v}
      {"jmp", off} -> %{state | ran: Map.put(ran, pos, true), pos: pos + off}
      :end_of_input -> {:end_of_input, state}
    end
  end
end
