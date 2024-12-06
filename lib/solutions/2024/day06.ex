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
          {:ok, :visited}
      end)

    start =
      receive do
        {:start_pos, {x, y}} -> {x, y}
      end

    {grid, start, :n}
  end

  def part_one({grid, start, dir}) do
    {grid, start, dir}
    grid = loop_until_quits(grid, start, dir)
    Enum.count(grid, fn {_, v} -> v == :visited end)
  end

  defp loop_until_quits(grid, pos, dir) do
    next_pos = Grid.translate(pos, dir, 1)

    case Map.get(grid, next_pos) do
      :obst -> loop_until_quits(grid, pos, rotate(dir))
      :floor -> loop_until_quits(Map.put(grid, next_pos, :visited), next_pos, dir)
      :visited -> loop_until_quits(grid, next_pos, dir)
      nil -> grid
    end
  end

  defp rotate(:n), do: :e
  defp rotate(:e), do: :s
  defp rotate(:s), do: :w
  defp rotate(:w), do: :n

  # def part_two({grid,start}) do
  #   {grid,start}
  # end
end
