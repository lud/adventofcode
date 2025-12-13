defmodule AdventOfCode.Solutions.Y19.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.stream!(trim: true) |> Enum.map(&parse_line/1)
  end

  defp parse_line(moves) do
    moves |> String.split(",") |> Enum.map(&parse_move/1)
  end

  defp parse_move(<<l, int_str::binary>>), do: {<<l>>, String.to_integer(int_str)}

  def part_one([wire_a, wire_b]) do
    grid_a = wire_grid(wire_a, {0, 0}, %{}, 0)
    grid_b = wire_grid(wire_b, {0, 0}, %{}, 0)

    Map.keys(grid_b)
    |> Enum.filter(&Map.has_key?(grid_a, &1))
    |> Enum.min_by(&manhattan_distance/1)
    |> manhattan_distance()
  end

  defp wire_grid(moves, pos, grid, step \\ 0)

  defp wire_grid([h | t], {x, y}, grid, step) do
    [{next_pos, step} | _] =
      positions =
      case h do
        {"R", n} -> Enum.map(n..1//-1, fn add -> {{x + add, y}, step + add} end)
        {"L", n} -> Enum.map(-n..-1//+1, fn add -> {{x + add, y}, step - add} end)
        {"D", n} -> Enum.map(n..1//-1, fn add -> {{x, y + add}, step + add} end)
        {"U", n} -> Enum.map(-n..-1//1, fn add -> {{x, y + add}, step - add} end)
      end

    grid = Map.merge(grid, Map.new(positions))
    wire_grid(t, next_pos, grid, step)
  end

  defp wire_grid([], _, grid, _) do
    grid
  end

  defp manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end

  def part_two([wire_a, wire_b]) do
    grid_a = wire_grid(wire_a, {0, 0}, %{})
    grid_b = wire_grid(wire_b, {0, 0}, %{})

    grid_b
    |> Enum.filter(fn {pos, _} -> Map.has_key?(grid_a, pos) end)
    |> Enum.reduce(:infinity, fn {{x, y}, steps_b}, best ->
      steps_a = Map.fetch!(grid_a, {x, y})
      min(best, steps_a + steps_b)
    end)
  end
end
