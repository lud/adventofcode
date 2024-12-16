defmodule AdventOfCode.Solutions.Y24.Day15 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    all = input |> Input.read!() |> String.trim()
    [grid, moves] = String.split(all, "\n\n")

    {grid, _} =
      Grid.parse_lines(String.split(grid, "\n"), fn
        _, ?# ->
          {:ok, :wall}

        _, ?. ->
          :ignore

        _, ?O ->
          {:ok, :crate}

        xy, ?@ ->
          send(self(), {:start_pos, xy})
          {:ok, :bot}
      end)

    moves = parse_moves(moves)
    start = receive(do: ({:start_pos, s} -> s))
    {grid, moves, start}
  end

  defp parse_moves(moves) do
    for <<m <- moves>>, m != ?\n, do: parse_move(m)
  end

  defp parse_move(?^), do: :n
  defp parse_move(?>), do: :e
  defp parse_move(?v), do: :s
  defp parse_move(?<), do: :w

  def part_one({grid, moves, start}) do
    {grid, _} =
      Enum.reduce(moves, {grid, start}, fn direction, {grid, pos} ->
        case check_move(grid, direction, pos) do
          :blocked ->
            {grid, pos}

          {:ok, [{_, {bot_pos, :bot}} | _] = changes} ->
            {_grid = apply_moves(grid, changes), bot_pos}
        end
      end)

    calc_gps(grid)
  end

  defp check_move(grid, direction, pos) do
    value = Map.fetch!(grid, pos)
    next = Grid.translate(pos, direction)

    case Map.get(grid, next) do
      :wall ->
        :blocked

      nil ->
        {:ok, [{pos, {next, value}}]}

      :crate ->
        case check_move(grid, direction, next) do
          :blocked -> :blocked
          {:ok, changes} -> {:ok, [{pos, {next, value}} | changes]}
        end
    end
  end

  defp apply_moves(grid, changes) do
    deletions = Enum.map(changes, fn {prev, _} -> prev end)
    new_values = Map.new(changes, fn {_, xy_v} -> xy_v end)

    grid
    |> Map.drop(deletions)
    |> Map.merge(new_values)
  end

  defp calc_gps(grid) do
    Enum.reduce(grid, 0, fn
      {{x, y}, :crate}, acc -> acc + x + 100 * y
      {{x, y}, :CL}, acc -> acc + x + 100 * y
      _, acc -> acc
    end)
  end

  def part_two({grid, moves, start}) do
    grid = expand_grid(grid)
    {start, _} = expand_xy(start)

    {grid, _} =
      Enum.reduce(moves, {grid, start}, fn direction, {grid, pos} ->
        case check_move_2(grid, direction, pos) do
          :blocked ->
            {grid, pos}

          {:ok, [{_, {bot_pos, :bot}} | _] = changes} ->
            {_grid = apply_moves(grid, changes), bot_pos}
        end
      end)

    calc_gps(grid)
  end

  defp expand_grid(grid) do
    grid
    |> Enum.flat_map(fn {{x, y}, type} ->
      {left, right} = expand_xy({x, y})

      case type do
        :crate -> [{left, :CL}, {right, :CR}]
        :wall -> [{left, :wall}, {right, :wall}]
        :bot -> [{left, :bot}]
      end
    end)
    |> Map.new()
  end

  defp expand_xy({x, y}) do
    x = x * 2
    {{x, y}, {x + 1, y}}
  end

  defp check_move_2(_grid, _direction, :ignore_pos) do
    {:ok, []}
  end

  defp check_move_2(grid, direction, pos) do
    value = Map.fetch!(grid, pos)

    next = Grid.translate(pos, direction)

    case Map.get(grid, next) do
      :wall ->
        :blocked

      nil ->
        {:ok, [{pos, {next, value}}]}

      crate when crate in [:CR, :CL] ->
        other_half_pos = other_half(next, crate, direction)

        with {:ok, changes} <- check_move_2(grid, direction, next),
             {:ok, changes2} <- check_move_2(grid, direction, other_half_pos) do
          {:ok, [{pos, {next, value}} | merge_changes(changes, changes2)]}
        end
    end
  end

  defp other_half(_pos, :CR, :e), do: :ignore_pos
  defp other_half(pos, :CR, _), do: Grid.translate(pos, :w)
  defp other_half(_pos, :CL, :w), do: :ignore_pos
  defp other_half(pos, :CL, _), do: Grid.translate(pos, :e)

  defp merge_changes(a, b) do
    a ++ b
  end
end
