defmodule AdventOfCode.Solutions.Y24.Day06 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    grid =
      input
      |> Input.stream!()
      |> Grid.parse_stream(fn
        _, "#" ->
          {:ok, :obst}

        {x, y}, "^" ->
          Process.put(:start_pos, {x, y})
          {:ok, :n}

        _, _ ->
          :ignore
      end)

    start = Process.get(:start_pos)
    Process.delete(:start_pos)

    {0, xo, 0, yo} = Grid.bounds(grid)
    {grid, start, :n, {xo, yo}}
  end

  def part_one({grid, start, dir, {xo, yo}}) do
    grid
    |> loop_until_quits(start, dir, {xo, yo}, %{start => true})
    |> map_size()
  end

  defp loop_until_quits(grid, pos, dir, {xo, yo}, acc) do
    {x, y} = next_pos = Grid.translate(pos, dir, 1)

    case Map.get(grid, next_pos) do
      :obst ->
        loop_until_quits(grid, pos, rotate(dir), {xo, yo}, acc)

      nil when x in 0..xo//1 and y in 0..yo//1 ->
        loop_until_quits(grid, next_pos, dir, {xo, yo}, Map.put(acc, next_pos, true))

      nil ->
        acc

      _ ->
        loop_until_quits(grid, next_pos, dir, {xo, yo}, Map.put(acc, next_pos, true))
    end
  end

  defp rotate(:n), do: :e
  defp rotate(:e), do: :s
  defp rotate(:s), do: :w
  defp rotate(:w), do: :n

  def part_two({grid, start, dir, {xo, yo}}) do
    candidates =
      grid
      |> loop_until_quits(start, dir, {xo, yo}, %{})
      |> Map.keys()

    :persistent_term.put(:grid, grid)

    parent = self()

    candidates
    |> Enum.map(
      &spawn_link(fn ->
        grid = Map.put(:persistent_term.get(:grid), &1, :obst)
        one_or_zero = loop_value(grid, start, dir, {xo, yo})
        send(parent, one_or_zero)
      end)
    )
    |> Enum.reduce(0, fn _, acc ->
      receive do
        n -> acc + n
      end
    end)
  end

  defp loop_value(grid, pos, dir, {xo, yo}) do
    {x, y} = next_pos = Grid.translate(pos, dir, 1)

    case Map.get(grid, next_pos) do
      :obst ->
        loop_value(grid, pos, rotate(dir), {xo, yo})

      ^dir ->
        1

      _ when x in 0..xo//1 and y in 0..yo//1 ->
        loop_value(Map.put(grid, next_pos, dir), next_pos, dir, {xo, yo})

      nil ->
        0
    end
  end
end
