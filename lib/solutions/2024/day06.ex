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
          send(self(), {:start_pos, {x, y}})
          {:ok, :n}
      end)

    start =
      receive do
        {:start_pos, {x, y}} -> {x, y}
      end

    {grid, start, :n}
  end

  def part_one({grid, start, dir}) do
    grid = loop_until_quits(grid, start, dir)
    Enum.count(grid, fn {_, v} -> v == :n end)
  end

  defp loop_until_quits(grid, pos, dir) do
    next_pos = Grid.translate(pos, dir, 1)

    # In part1, always use :n to mean "visited"

    case Map.get(grid, next_pos) do
      :obst -> loop_until_quits(grid, pos, rotate(dir))
      :floor -> loop_until_quits(Map.put(grid, next_pos, :n), next_pos, dir)
      :n -> loop_until_quits(grid, next_pos, dir)
      nil -> grid
    end
  end

  defp rotate(:n), do: :e
  defp rotate(:e), do: :s
  defp rotate(:s), do: :w
  defp rotate(:w), do: :n

  def part_two({grid, start, dir}) do
    {grid, acc} = loop_find_new(grid, start, dir, [])
    grid = Enum.reduce(acc, grid, fn p, g -> Map.put(g, p, :O) end)
    print(grid)
    length(acc)
  end

  defp print(grid) do
    Grid.print(grid, &print_part/1)
  end

  defp print_part(part) do
    case part do
      :obst -> "#"
      :floor -> "."
      :n -> "|"
      :e -> "-"
      :s -> "|"
      :w -> "-"
      :O -> "O"
      [t, :floor] -> print_part(t)
      [_ | _] -> "+"
    end
  end

  defp loop_find_new(grid, pos, dir, acc) do
    # print(grid)
    # grid |> dbg()

    next_pos = Grid.translate(pos, dir, 1)

    case Map.get(grid, next_pos) do
      :obst ->
        loop_find_new(grid, pos, rotate(dir), acc)

      nil ->
        {grid, acc}

      _ ->
        case cast_ray(grid, next_pos, rotate(dir)) do
          :looping -> loop_find_new(visit(grid, next_pos, dir), next_pos, dir, [Grid.translate(next_pos, dir) | acc])
          :nope -> loop_find_new(visit(grid, next_pos, dir), next_pos, dir, acc)
        end
    end
  end

  defp visit(grid, pos, dir) do
    Map.update(grid, pos, [dir], &[dir | List.wrap(&1)])
  end

  defp cast_ray(grid, pos, dir) do
    e =
      Stream.iterate(0, &(&1 + 1))
      |> Stream.map(&Grid.translate(pos, dir, &1))
      |> Stream.map(&Map.get(grid, &1))
      |> Stream.flat_map(fn
        nil -> [nil]
        x -> List.wrap(x)
      end)
      |> Enum.take_while(&(&1 not in [:obst, nil]))
      |> dbg()

    length(e) |> dbg()

    e
    |> Enum.any?(&(&1 == dir))
    |> case do
      true -> :looping
      false -> :nope
    end
  end
end
