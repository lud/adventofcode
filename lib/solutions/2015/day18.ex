defmodule AdventOfCode.Solutions.Y15.Day18 do
  alias AoC.Input
  alias AdventOfCode.Grid

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
    solve(problem, steps, fn xy, val, grid ->
      case {val, count_neighs(xy, grid)} do
        {@on, 2} -> @on
        {@on, 3} -> @on
        {@on, _} -> @off
        {@off, 3} -> @on
        {@off, _} -> @off
      end
    end)
  end

  def part_two(problem, steps \\ 100) do
    {xa, xo, ya, yo} = Grid.bounds(problem)

    fixed_1 = {xa, ya}
    fixed_2 = {xa, yo}
    fixed_3 = {xo, ya}
    fixed_4 = {xo, yo}

    problem =
      Map.merge(problem, %{
        fixed_1 => @on,
        fixed_2 => @on,
        fixed_3 => @on,
        fixed_4 => @on
      })

    solve(problem, steps, fn
      ^fixed_1, _, _ ->
        @on

      ^fixed_2, _, _ ->
        @on

      ^fixed_3, _, _ ->
        @on

      ^fixed_4, _, _ ->
        @on

      xy, val, grid ->
        case {val, count_neighs(xy, grid)} do
          {@on, 2} -> @on
          {@on, 3} -> @on
          {@on, _} -> @off
          {@off, 3} -> @on
          {@off, _} -> @off
        end
    end)
  end

  defp solve(problem, steps, evolve) do
    problem
    # |> print_grid()
    |> reduce(evolve, steps)
    |> sum_on()
  end

  defp reduce(grid, _evolve, 0) do
    grid
  end

  defp reduce(grid, evolve, n) do
    grid
    # |> print_grid()
    |> step(evolve)
    |> reduce(evolve, n - 1)
  end

  defp step(grid, evolve) do
    Map.new(grid, fn {xy, val} -> {xy, evolve.(xy, val, grid)} end)
  end

  defp count_neighs(xy, grid) do
    Map.take(grid, Grid.cardinal8(xy)) |> sum_on()
  end

  defp sum_on(grid) do
    Enum.reduce(grid, 0, fn {_, v}, acc -> acc + v end)
  end

  def print_grid(grid) do
    Grid.print(grid, fn
      1 -> "#"
      0 -> "."
    end)

    grid
  end
end
