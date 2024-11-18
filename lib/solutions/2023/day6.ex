defmodule AdventOfCode.Solutions.Y23.Day6 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    file |> Input.stream!(trim: true) |> Enum.take(2)
  end

  def parse_input([times, distances], :part_one) do
    times = int_list_no_header(times)
    distances = int_list_no_header(distances)
    Enum.zip(times, distances)
  end

  def parse_input(["Time: " <> times, "Distance: " <> distances], _) do
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
  end

  defp count_wins({time, best}) do
    0..time
    |> Enum.map(&hold_time_to_distance(&1, time))
    |> Enum.filter(&(&1 > best))
    |> length()
  end

  defp hold_time_to_distance(hold, time) do
    duration = time - hold
    _distance = hold * duration
  end

  def part_two({time, distance_record}) do
    half = trunc(time / 2)
    left = binary_search(&find_left_bound(&1, time, distance_record), 1, half)
    right = binary_search(&find_right_bound(&1, time, distance_record), half, time)
    right - left + 1
  end

  defp find_left_bound(hold, time, record) do
    left = hold_time_to_distance(hold - 1, time)
    right = hold_time_to_distance(hold, time)

    case {left, right} do
      {d1, d2} when d1 < record and d2 > record -> :eq
      {_d1, d2} when d2 < record -> :lt
      {d1, _d2} when d1 > record -> :gt
    end
  end

  defp find_right_bound(hold, time, record) do
    left = hold_time_to_distance(hold, time)
    right = hold_time_to_distance(hold + 1, time)

    case {left, right} do
      {d1, d2} when d1 > record and d2 < record -> :eq
      {_d1, d2} when d2 > record -> :lt
      {d1, _d2} when d1 < record -> :gt
    end
  end

  def binary_search(ask, min, max) do
    n = div(min + max, 2)

    case ask.(n) do
      # n is lower than the answer
      :lt -> binary_search(ask, n + 1, max)
      # n is greater than the answer
      :gt -> binary_search(ask, min, n - 1)
      :eq -> n
    end
  end
end
