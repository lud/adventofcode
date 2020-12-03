defmodule Aoe.Y20.Day3 do
  alias Aoe.Input, warn: false
  alias Aoe.Utils, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    Stream.map(input, &String.to_charlist/1)
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    count_trees(problem, {3, 1})
  end

  @spec part_two(problem) :: integer
  def part_two(problem) do
    [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]
    |> Task.async_stream(&count_trees(problem, &1), ordered: false, max_concurrency: 999)
    |> Stream.map(&elem(&1, 1))
    |> Enum.reduce(&*/2)
  end

  defp count_trees(problem, {right, down}) do
    problem
    |> Stream.take_every(down)
    |> Enum.reduce({0, map_width(problem), 0, right}, &reducer/2)
    |> elem(2)
  end

  defp map_width(problem) do
    length(Enum.at(problem, 0))
  end

  defp reducer(row, {x, width, trees, right}) do
    trees =
      case Enum.at(row, rem(x, width)) do
        ?# -> trees + 1
        ?. -> trees
      end

    {x + right, width, trees, right}
  end
end
