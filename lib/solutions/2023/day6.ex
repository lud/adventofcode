defmodule AdventOfCode.Y23.Day6 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    file |> Input.stream!(trim: true) |> Enum.take(2)
  end

  def parse_input([times, distances], :part_one) do
    times = int_list_no_header(times)
    distances = int_list_no_header(distances)
    Enum.zip(times, distances)
  end

  def parse_input(["Time: " <> times, "Distance: " <> distances], :part_two) do
    {single_int(times), single_int(distances)}
  end

  defp int_list_no_header(string) do
    string
    |> String.split(" ", trim: true)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
  end

  defp single_int(string) do
    string
    |> String.split(" ", trim: true)
    |> Enum.join()
    |> String.to_integer()
  end

  def part_one(problem) do
    problem
    |> Enum.map(&count_wins/1)
    |> Enum.product()
    |> dbg()
  end

  defp count_wins({time, best}) do
    0..time
    |> Enum.map(fn speed = hold ->
      duration = time - hold
      _distance = speed * duration
    end)
    |> Enum.filter(&(&1 > best))
    |> length()
  end

  def part_two(problem) do
    count_wins(problem)
  end
end
