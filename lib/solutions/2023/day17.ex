defmodule AdventOfCode.Solutions.Y23.Day17 do
  alias AoC.Input, warn: false
  alias AdventOfCode.Grid, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Grid.parse_stream(fn x -> {:ok, String.to_integer(x)} end)
  end

  def part_one(problem), do: solve(problem, :part_one)
  def part_two(problem), do: solve(problem, :part_two)

  defp solve(grid, part) do
    target_xy = {Grid.max_x(grid), Grid.max_y(grid)}

    start_poses =
      :gb_sets.from_list([
        {0, {0, 0}, {:e, 0}},
        {0, {0, 0}, {:s, 0}}
      ])

    find_target(start_poses, target_xy, %{}, grid, part)
  end

  defp find_target(open, target_xy, seen, grid, part) do
    case :gb_sets.take_smallest(open) do
      {{cost, ^target_xy, _}, _} -> cost
      {node, open} -> discover_node(node, open, target_xy, seen, grid, part)
    end
  end

  defp discover_node(node, open, target_xy, seen, grid, part) do
    next_poses = next_poses(node, grid, part)

    {next_poses, seen} =
      Enum.flat_map_reduce(next_poses, seen, fn {_, xy, dc} = node, seen ->
        key = {xy, dc}

        if Map.has_key?(seen, key) do
          {[], seen}
        else
          {[node], Map.put(seen, key, true)}
        end
      end)

    open = Enum.reduce(next_poses, open, &:gb_sets.add/2)
    find_target(open, target_xy, seen, grid, part)
  end

  # -- Next positions for part two --------------------------------------------

  defp next_poses({cost, xy, {dir, count}}, grid, :part_two) do
    can_continue? = count <= 9
    can_turn? = count >= 4

    poses =
      if can_continue? do
        xy_cont = Grid.translate(xy, dir)

        case Map.fetch(grid, xy_cont) do
          {:ok, add_cost} -> [{cost + add_cost, xy_cont, {dir, count + 1}}]
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
          {:ok, add_cost} -> [{cost + add_cost, left_xy, {left_dir, 1}} | poses]
          :error -> poses
        end

      poses =
        case Map.fetch(grid, right_xy) do
          {:ok, add_cost} -> [{cost + add_cost, right_xy, {right_dir, 1}} | poses]
          :error -> poses
        end

      poses
    else
      poses
    end
  end

  # -- Next positions for part one --------------------------------------------

  defp next_poses({cost, xy, {dir, count}}, grid, :part_one) do
    can_continue? = count < 3

    poses =
      if can_continue? do
        xy_cont = Grid.translate(xy, dir)

        case Map.fetch(grid, xy_cont) do
          {:ok, add_cost} -> [{cost + add_cost, xy_cont, {dir, count + 1}}]
          :error -> []
        end
      else
        []
      end

    left_dir = turn_left(dir)
    right_dir = turn_right(dir)
    left_xy = Grid.translate(xy, left_dir)
    right_xy = Grid.translate(xy, right_dir)

    poses =
      case Map.fetch(grid, left_xy) do
        {:ok, add_cost} -> [{cost + add_cost, left_xy, {left_dir, 1}} | poses]
        :error -> poses
      end

    poses =
      case Map.fetch(grid, right_xy) do
        {:ok, add_cost} -> [{cost + add_cost, right_xy, {right_dir, 1}} | poses]
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
