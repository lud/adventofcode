defmodule AdventOfCode.Combinations do
  def of([_ | _] = items, 1) do
    Enum.map(items, &[&1])
  end

  def of([_ | _] = items, len) when len > 1 do
    range = 2..len

    acc_in = Enum.map(items, &[&1])

    Enum.reduce(range, acc_in, fn _, acc ->
      Stream.flat_map(acc, fn tail -> Stream.map(items, &[&1 | tail]) end)
    end)
  end
end
