defmodule AdventOfCode.Solutions.Y25.Day08 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [x, y, z] = String.split(line, ",")

    {
      String.to_integer(x),
      String.to_integer(y),
      String.to_integer(z)
    }
  end

  def part_one(xyzs, n_pairs \\ 1000) do
    circuits = Map.new(Enum.with_index(xyzs))

    xyzs
    |> all_distances()
    |> Enum.take(n_pairs)
    |> Enum.reduce(circuits, fn {{a, b}, _}, circuits -> merge_circuits(circuits, a, b) end)
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.map(fn {_, list} -> length(list) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def part_two(xyzs, _ \\ nil) do
    circuits = Map.new(Enum.with_index(xyzs))

    xyzs
    |> all_distances()
    |> Enum.reduce_while(circuits, fn {{a, b}, _}, circuits ->
      circuits = merge_circuits(circuits, a, b)

      if single_circuit?(circuits),
        do: {:halt, x(a) * x(b)},
        else: {:cont, circuits}
    end)
  end

  defp all_distances(xyzs) do
    all_distances = for a <- xyzs, b <- xyzs, a != b, into: %{}, do: {{min(a, b), max(a, b)}, distance(a, b)}
    Enum.sort(all_distances, fn {_, dist_a}, {_, dist_b} -> dist_a <= dist_b end)
  end

  defp merge_circuits(circuits, xyz_a, xyz_b) do
    circ_a = Map.fetch!(circuits, xyz_a)
    circ_b = Map.fetch!(circuits, xyz_b)

    Map.new(circuits, fn
      {xyz, ^circ_a} -> {xyz, circ_b}
      other -> other
    end)
  end

  defp distance({xa, ya, za}, {xb, yb, zb}) do
    :math.sqrt(
      :math.pow(xb - xa, 2) +
        :math.pow(yb - ya, 2) +
        :math.pow(zb - za, 2)
    )
  end

  defp single_circuit?(map) do
    case Enum.uniq(Map.values(map)) do
      [_, _ | _] -> false
      [_] -> true
    end
  end

  defp x({x, _, _}), do: x
end
