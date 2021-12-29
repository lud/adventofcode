defmodule Aoe.Y21.Day24 do
  alias Aoe.Input, warn: false
  alias Aoe.Y21.Day24.Program

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    # Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
    "nope"
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    nil
  end

  # @td List.duplicate(nil, 14) |> List.to_tuple()
  @td 0

  def part_one(_problem) do
    z = 0
    index = 0
    seen = %{}
    states = [{_z = 0, _digits = @td}]
    states = run_index(0, states, seen)
    states = run_index(1, states, seen)
    states = run_index(2, states, seen)
    states = run_index(3, states, seen)
    states = run_index(4, states, seen)
    states = run_index(5, states, seen)
    states = run_index(6, states, seen)
    states = run_index(7, states, seen)
    states = run_index(8, states, seen)
    states = run_index(9, states, seen)
    states = run_index(10, states, seen)
    states = run_index(11, states, seen)
    states = run_index(12, states, seen)
    states = run_index(13, states, seen)
  end

  defp run_index(index, states, seen) do
    IO.puts("-------- index #{index}")
    IO.puts("before: #{length(states)}")

    seen =
      Enum.reduce(1..9, seen, fn w, seen ->
        IO.puts("w = #{w}")

        Enum.reduce(states, seen, fn {z, digits}, seen ->
          z = Program.run(index, w, z)
          digits = digits * 10 + w

          case Map.get(seen, z) do
            nil -> Map.put(seen, z, digits)
            other_digits when other_digits >= digits -> seen
            _ -> Map.put(seen, z, digits)
          end
        end)
      end)

    states = Map.to_list(seen)
    IO.puts("after: #{length(states)}")
    states
  end

  defp keep_best(seen, z, digits) do
  end

  def part_two(problem) do
    problem
  end
end
