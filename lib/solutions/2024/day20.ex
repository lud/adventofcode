defmodule AdventOfCode.Solutions.Y24.Day20 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    {grid, _, %{start: start, finish: finish}} =
      input
      |> Input.stream!(trim: true)
      |> Grid.parse_lines(fn
        _, ?# -> :ignore
        _, ?. -> {:ok, :track}
        xy, ?E -> {:ok, :track, finish: xy}
        xy, ?S -> {:ok, :track, start: xy}
      end)

    {grid, start, finish}
  end

  def part_one({grid, start, finish}, save_at_least \\ 100) do
    solve(grid, start, finish, 2, save_at_least)
  end

  def part_two({grid, start, finish}, save_at_least \\ 100) do
    solve(grid, start, finish, 20, save_at_least)
  end

  defp solve(grid, start, finish, max_cheat, save_at_least) do
    track = compute_path(grid, start, finish)
    count_cheats(track, max_cheat, save_at_least)
  end

  defp compute_path(grid, start, finish) do
    compute_path(grid, start, _prev = nil, finish, 0, [])
  end

  defp compute_path(_grid, finish, _prev, finish, index, acc) do
    :lists.reverse([{finish, index} | acc])
  end

  defp compute_path(grid, pos, prev, finish, index, acc) do
    [next] = pos |> Grid.cardinal4() |> Enum.filter(&(&1 != prev && Map.has_key?(grid, &1)))
    compute_path(grid, next, pos, finish, index + 1, [{pos, index} | acc])
  end

  defp count_cheats(track, max_cheat, save_at_least, count \\ 0)

  defp count_cheats([_last], _, _, count) do
    count
  end

  defp count_cheats([current_pos | track], max_cheat, save_at_least, count) do
    {activation_pos, activation_index} = current_pos

    count =
      track
      |> Enum.drop(save_at_least + 1)
      |> Enum.reduce(count, fn {dest_pos, dest_index}, count ->
        cheat_dist = manhattan(activation_pos, dest_pos)

        if cheat_dist <= max_cheat && dest_index - activation_index - cheat_dist >= save_at_least do
          count + 1
        else
          count
        end
      end)

    count_cheats(track, max_cheat, save_at_least, count)
  end

  def manhattan({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)
end
