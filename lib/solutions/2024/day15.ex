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
        Grid.print(grid, &printer/1)

        case check_move(grid, direction, pos) do
          :blocked ->
            {grid, pos}

          {:ok, [{_, {bot_pos, :bot}} | _] = changes} ->
            {_grid = apply_moves(grid, changes), bot_pos}
        end
      end)

    Grid.print(grid, &printer/1)

    calc_gps(grid)
  end

  defp printer(nil), do: ?.
  defp printer(:wall), do: ?#
  defp printer(:crate), do: ?O
  defp printer(:bot), do: ?@

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

    grid = Map.drop(grid, deletions)
    grid = Map.merge(grid, new_values)
  end

  defp calc_gps(grid) do
    Enum.reduce(grid, 0, fn
      {{x, y}, :crate}, acc -> acc + x + 100 * y
      _, acc -> acc
    end)
  end

  # def part_two(problem) do
  #   problem
  # end
end
