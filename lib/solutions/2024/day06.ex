defmodule AdventOfCode.Solutions.Y24.Day06 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    grid =
      input
      |> Input.stream!()
      |> Grid.parse_stream(fn
        _, "." ->
          {:ok, :floor}

        _, "#" ->
          {:ok, :obst}

        {x, y}, "^" ->
          Process.put(:start_pos, {x, y})
          {:ok, :n}
      end)

    start = Process.get(:start_pos)
    Process.delete(:start_pos)

    {grid, start, :n}
  end

  def part_one({grid, start, dir}) do
    grid
    |> loop_until_quits(start, dir, %{start => true})
    |> map_size()
  end

  defp loop_until_quits(grid, pos, dir, acc) do
    next_pos = Grid.translate(pos, dir, 1)

    case Map.get(grid, next_pos) do
      :obst -> loop_until_quits(grid, pos, rotate(dir), acc)
      nil -> acc
      _ -> loop_until_quits(grid, next_pos, dir, Map.put(acc, next_pos, true))
    end
  end

  defp rotate(:n), do: :e
  defp rotate(:e), do: :s
  defp rotate(:s), do: :w
  defp rotate(:w), do: :n

  def part_two({grid, start, dir}) do
    candidates =
      grid
      |> loop_until_quits(start, dir, %{})
      |> Map.keys()

    :persistent_term.put(:grid, grid)

    this = self()

    candidates
    |> Enum.map(
      &spawn_link(fn ->
        send(this, looping?(:persistent_term.get(:grid), start, dir, &1))
      end)
    )
    |> Enum.reduce(0, fn _, acc ->
      receive do
        true -> acc + 1
        false -> acc
      end
    end)
  end

  defp looping?(grid, pos, dir, obst) do
    next_pos = Grid.translate(pos, dir, 1)

    next_value =
      case next_pos do
        ^obst -> :obst
        _ -> Map.get(grid, next_pos)
      end

    case next_value do
      :obst -> looping?(grid, pos, rotate(dir), obst)
      ^dir -> true
      nil -> false
      _ -> looping?(Map.put(grid, next_pos, dir), next_pos, dir, obst)
    end
  end
end
