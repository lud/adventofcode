defmodule AdventOfCode.Y15.Day18 do
  alias AoC.Input
  alias AoC.Grid

  @on 1
  @off 0

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Grid.parse_stream(&parse_char/1)
  end

  defp parse_char("#"), do: {:ok, @on}
  defp parse_char("."), do: {:ok, @off}

  def part_one(problem, steps \\ 100) do
    problem
    |> reduce(steps)
    |> sum_on()
  end

  defp reduce(grid, 0) do
    grid
  end

  defp reduce(grid, n) do
    Grid.print_map(grid, fn
      1 -> "#"
      0 -> "."
    end)

    grid = step(grid)
    reduce(grid, n - 1)
  end

  defp step(grid) do
    Map.new(grid, fn {xy, val} ->
      val =
        case {val, count_neighs(xy, grid)} do
          {@on, 2} -> @on
          {@on, 3} -> @on
          {@on, _} -> @off
          {@off, 3} -> @on
          {@off, _} -> @off
        end

      {xy, val}
    end)
  end

  defp count_neighs(xy, grid) do
    Map.take(grid, Grid.cardinal8(xy)) |> sum_on()
  end

  defp sum_on(grid) do
    Enum.reduce(grid, 0, fn {_, v}, acc -> acc + v end)
  end

  # def part_two(problem) do
  #   problem
  # end
end
