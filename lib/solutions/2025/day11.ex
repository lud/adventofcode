defmodule AdventOfCode.Solutions.Y25.Day11 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Map.new(&parse_line/1)
  end

  defp parse_line(line) do
    <<inp::binary-size(3), ": ", rest::binary>> = line
    {inp, String.split(rest)}
  end

  def part_one(full_io) do
    count_paths(full_io, "you", "out")
  end

  defp count_paths(full_io, start, finish) do
    counts = count_paths_loop(full_io, start, finish, Map.put(%{"out" => 0}, finish, 1))
    Map.fetch!(counts, start)
  end

  defp count_paths_loop(full_io, current, finish, acc) do
    exits = Map.fetch!(full_io, current)

    acc =
      Enum.reduce(exits, acc, fn exit_, acc ->
        if Map.has_key?(acc, exit_) do
          acc
        else
          count_paths_loop(full_io, exit_, finish, acc)
        end
      end)

    value = Enum.sum_by(exits, &Map.fetch!(acc, &1))

    Map.put(acc, current, value)
  end

  def part_two(full_io) do
    {step1, step2} =
      if count_paths(full_io, "fft", "dac") > 0 do
        {"fft", "dac"}
      else
        true = count_paths(full_io, "dac", "fft") > 0
        {"dac", "fft"}
      end

    count_paths(full_io, "svr", step1) *
      count_paths(full_io, step1, step2) *
      count_paths(full_io, step2, "out")
  end
end
