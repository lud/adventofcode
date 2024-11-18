defmodule AdventOfCode.Y15.Day3 do
  alias AoC.Input, warn: false
  alias AdventOfCode.Grid

  def read_file(file, _part) do
    Input.read!(file) |> String.trim()
  end

  def parse_input(input, _part) do
    input |> String.graphemes()
  end

  def part_one(problem) do
    map = reduce_santa(problem, {0, 0}, %{{0, 0} => 1})
    map_size(map)
  end

  def part_two(problem) do
    map = reduce_both(problem, {{0, 0}, {0, 0}}, %{{0, 0} => 1})
    map_size(map)
  end

  defp reduce_santa([h | t], pos, map) do
    new_pos = Grid.translate(pos, dir(h))
    new_map = Map.update(map, new_pos, 1, &(&1 + 1))
    reduce_santa(t, new_pos, new_map)
  end

  defp reduce_santa([], _pos, map) do
    map
  end

  defp reduce_both([h, r | t], {pos_santa, pos_bot}, map) do
    dir_santa = dir(h)
    dir_bot = dir(r)

    new_pos_santa = Grid.translate(pos_santa, dir_santa)
    new_pos_bot = Grid.translate(pos_bot, dir_bot)

    new_map =
      map
      |> Map.update(new_pos_santa, 1, &(&1 + 1))
      |> Map.update(new_pos_bot, 1, &(&1 + 1))

    reduce_both(t, {new_pos_santa, new_pos_bot}, new_map)
  end

  defp reduce_both([], _pos, map) do
    map
  end

  defp dir("^"), do: :n
  defp dir("v"), do: :s
  defp dir("<"), do: :w
  defp dir(">"), do: :e
end
