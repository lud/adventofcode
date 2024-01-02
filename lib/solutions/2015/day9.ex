defmodule AdventOfCode.Y15.Day9 do
  alias AoC.Input

  def read_file(file, _part) do
    # Return each line
    Input.stream!(file, trim: true)
    # Or return the whole file
    # Input.read!(file)
  end

  def parse_input(input, _part) do
    input
  end

  def part_one(problem) do
    problem

    [] |> show_perms()
    [1] |> show_perms()
    [1, 2] |> show_perms()
    [1, 2, 3] |> show_perms()

    1..10
    |> Enum.reverse()
    |> permutations_stream()
    |> Stream.map(fn i -> i |> IO.inspect(label: ~S/=========/) end)
    |> Enum.take(10)
  end

  defp show_perms(list) do
    perms = list |> permutations_stream() |> Enum.to_list() |> Enum.sort()
    list |> IO.inspect(label: ~S/list/)
    perms |> IO.inspect(label: ~S/perms/)
  end

  # def part_two(problem) do
  #   problem
  # end

  def permutations_stream([_ | count] = list) do
    stream = [{[], list}]

    count
    |> Enum.reduce(stream, fn _iter, stream -> Stream.flat_map(stream, &permutations/1) end)
    |> Stream.map(&unwrap_permutations/1)
  end

  def permutations_stream([]) do
    []
  end

  defp permutations({used, left}) do
    Stream.map(left, fn item -> {[item | used], left -- [item]} end)
  end

  defp unwrap_permutations({used, [last]}) do
    [last | used]
  end
end
