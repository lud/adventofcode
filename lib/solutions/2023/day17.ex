defmodule AdventOfCode.Y23.Day17 do
  alias AoC.Input, warn: false
  alias AoC.Grid, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Grid.parse_stream(fn x -> {:ok, String.to_integer(x)} end)
  end

  def part_one(grid) do
    target_xy = {Grid.max_x(grid), Grid.max_y(grid)} |> dbg()

    start_poses = [
      {{0, 0}, {:e, 0}, 0},
      {{0, 0}, {:s, 0}, 0}
    ]

    find_target(start_poses, target_xy, %{}, grid, :part_one)
  end

  def part_two(grid) do
    target_xy = {Grid.max_x(grid), Grid.max_y(grid)} |> dbg()

    start_poses = [
      {{0, 0}, {:e, 0}, 0},
      {{0, 0}, {:s, 0}, 0}
    ]

    find_target(start_poses, target_xy, %{}, grid, :part_two)
  end

  defp find_target([{target_xy, _, cost} | open], target_xy, seen, grid, _) do
    cost
  end

  defp find_target([h | open], target_xy, seen, grid, part) do
    {next_poses, seen} =
      next_poses(h, grid, part)
      |> Enum.flat_map_reduce(seen, fn {xy, dc, _} = node, seen ->
        key = {xy, dc}

        if Map.has_key?(seen, key) do
          {[], seen}
        else
          {[node], Map.put(seen, key, true)}
        end
      end)

    open = insert_all(next_poses, open)
    find_target(open, target_xy, seen, grid, part)
  end

  defp insert_all([h | t], open) do
    insert_all(t, insert(h, open))
  end

  defp insert_all([], open) do
    open
  end

  defp insert({xy, dc, cost} = new_best, [{_xy, _dc, best} = cand | open]) when cost <= best do
    [new_best, cand | open]
  end

  defp insert(new, [best | open]) do
    [best | insert(new, open)]
  end

  defp insert(new, []) do
    [new]
  end

  # -- Next positions for part two --------------------------------------------

  defp next_poses({xy, {dir, count}, cost}, grid, :part_two) do
    can_continue? = count < 10
    can_turn? = count > 4

    poses =
      if can_continue? do
        xy_cont = Grid.translate(xy, dir)

        case Map.fetch(grid, xy_cont) do
          {:ok, add_cost} -> [{xy_cont, {dir, count + 1}, cost + add_cost}]
          :error -> []
        end
      else
        []
      end

    if can_turn? do
      left_dir = turn_left(dir)
      right_dir = turn_right(dir)
      left_xy = Grid.translate(xy, left_dir)
      right_xy = Grid.translate(xy, right_dir)

      poses =
        case Map.fetch(grid, left_xy) do
          {:ok, add_cost} -> [{left_xy, {left_dir, 1}, cost + add_cost} | poses]
          :error -> poses
        end

      poses =
        case Map.fetch(grid, right_xy) do
          {:ok, add_cost} -> [{right_xy, {right_dir, 1}, cost + add_cost} | poses]
          :error -> poses
        end

      poses
    else
      poses
    end
  end

  # -- Next positions for part one --------------------------------------------

  defp next_poses({xy, {dir, count}, cost}, grid, :part_one) when count < 3 do
    xy_cont = Grid.translate(xy, dir)

    poses =
      case Map.fetch(grid, xy_cont) do
        {:ok, add_cost} -> [{xy_cont, {dir, count + 1}, cost + add_cost}]
        :error -> []
      end

    left_dir = turn_left(dir)
    right_dir = turn_right(dir)
    left_xy = Grid.translate(xy, left_dir)
    right_xy = Grid.translate(xy, right_dir)

    poses =
      case Map.fetch(grid, left_xy) do
        {:ok, add_cost} -> [{left_xy, {left_dir, 1}, cost + add_cost} | poses]
        :error -> poses
      end

    poses =
      case Map.fetch(grid, right_xy) do
        {:ok, add_cost} -> [{right_xy, {right_dir, 1}, cost + add_cost} | poses]
        :error -> poses
      end

    poses
  end

  defp next_poses({xy, {dir, 3}, cost}, grid, :part_one) do
    poses = []

    left_dir = turn_left(dir)
    right_dir = turn_right(dir)
    left_xy = Grid.translate(xy, left_dir)
    right_xy = Grid.translate(xy, right_dir)

    poses =
      case Map.fetch(grid, left_xy) do
        {:ok, add_cost} -> [{left_xy, {left_dir, 1}, cost + add_cost} | poses]
        :error -> poses
      end

    poses =
      case Map.fetch(grid, right_xy) do
        {:ok, add_cost} -> [{right_xy, {right_dir, 1}, cost + add_cost} | poses]
        :error -> poses
      end

    poses
  end

  defp turn_left(:e), do: :n
  defp turn_left(:n), do: :w
  defp turn_left(:w), do: :s
  defp turn_left(:s), do: :e

  defp turn_right(:e), do: :s
  defp turn_right(:s), do: :w
  defp turn_right(:w), do: :n
  defp turn_right(:n), do: :e
end
