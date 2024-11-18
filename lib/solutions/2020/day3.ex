defmodule AdventOfCode.Solutions.Y20.Day3 do
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
    Stream.map(input, &String.to_charlist/1)
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    solution = count_trees(problem, {3, 1})
    # print_map(problem, {3, 1})
    solution
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

  def print_map(problem, {right, _}) do
    problem = Enum.to_list(problem)
    map_height = length(problem)
    move_width = map_height * right
    repeats = ceil(move_width / map_width(problem))
    IO.puts([IO.ANSI.light_white_background()])

    term_width = 60

    problem
    |> Enum.zip(Stream.iterate(0, &(&1 + right)))
    |> Enum.each(fn {chars, pos} ->
      chars
      |> List.duplicate(repeats)
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.map(
        &case &1 do
          {?#, ^pos} -> [IO.ANSI.red(), "木", IO.ANSI.default_color()]
          {?., ^pos} -> [IO.ANSI.green(), "✔️", IO.ANSI.default_color()]
          {?#, _} -> [IO.ANSI.green(), "木", IO.ANSI.default_color()]
          {?., _} -> " "
        end
      )
      |> Enum.drop(div(pos, term_width) * term_width)
      |> Enum.take(term_width)
      |> IO.puts()
    end)

    IO.puts([IO.ANSI.reset()])
  end
end
