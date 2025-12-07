defmodule AdventOfCode.Solutions.Y25.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    lines =
      input
      |> Input.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    [first_row | rows] = lines
    start = Enum.find_index(first_row, fn x -> x == ?S end)

    layers =
      Enum.map(rows, fn row ->
        for {?^, x} <- Enum.with_index(row),
            do: {x, true},
            into: %{}
      end)

    {start, layers}
  end

  def part_one({start, layers}) do
    {_last_positions, count} =
      Enum.reduce(layers, {[start], 0}, fn layer, {poses, count} ->
        {splitters, keep_positions} = Enum.split_with(poses, &Map.has_key?(layer, &1))
        count = count + length(splitters)
        split_positions = Enum.flat_map(splitters, &[&1 - 1, &1 + 1])
        new_positions = Enum.uniq(keep_positions ++ split_positions)
        {new_positions, count}
      end)

    count
  end

  def part_two({start_pos, layers}) do
    new_poscounts =
      Enum.reduce(layers, _init_poscounts = %{start_pos => 1}, fn layer, poscounts ->
        Enum.reduce(poscounts, %{}, fn {pos, n}, new_poscounts ->
          if Map.has_key?(layer, pos) do
            new_poscounts
            |> Map.update(pos - 1, n, &(&1 + n))
            |> Map.update(pos + 1, n, &(&1 + n))
          else
            Map.update(new_poscounts, pos, n, &(&1 + n))
          end
        end)
      end)

    Enum.sum_by(new_poscounts, &elem(&1, 1))
  end
end
