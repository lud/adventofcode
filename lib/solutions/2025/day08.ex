defmodule AdventOfCode.Solutions.Y25.Day08 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [x, y, z] = String.split(line, ",")
    {String.to_integer(x), String.to_integer(y), String.to_integer(z)}
  end

  def part_one(xyzs, n_pairs \\ 1000) do
    circuits = Map.new(Enum.with_index(xyzs), fn {xyz, circ} -> {circ, MapSet.new([xyz])} end)

    xyzs
    |> all_distances()
    |> Enum.take(n_pairs)
    |> Enum.reduce(circuits, fn {{a, b}, _}, circuits -> merge_circuits(circuits, a, b) end)
    |> Enum.map(fn {_, set} -> MapSet.size(set) end)
    |> Enum.sort(:desc)
    |> then(fn [a, b, c | _] -> a * b * c end)
  end

  def part_two(xyzs, _ \\ nil) do
    circuits = Map.new(Enum.with_index(xyzs), fn {xyz, circ} -> {circ, MapSet.new([xyz])} end)

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
    {_time, dists} = :timer.tc(fn -> do_all_distances(xyzs, []) end, :millisecond)
    # time |> IO.inspect(limit: :infinity, label: "time")
    dists
  end

  defp do_all_distances([h | t], acc) do
    acc = Enum.reduce(t, acc, &[{{h, &1}, distance(h, &1)} | &2])
    do_all_distances(t, acc)
  end

  defp do_all_distances([], acc) do
    Enum.sort(acc, fn {_, dist_a}, {_, dist_b} -> dist_a <= dist_b end)
  end

  defp merge_circuits(circuits, xyz_a, xyz_b) do
    {circ_a, group_a} = Enum.find(circuits, fn {_, items} -> xyz_a in items end)

    case Enum.find(circuits, fn {_, items} -> xyz_b in items end) do
      {^circ_a, _} ->
        circuits

      {circ_b, group_b} ->
        circuits
        |> Map.put(circ_b, MapSet.union(group_a, group_b))
        |> Map.delete(circ_a)
    end
  end

  defp distance({xa, ya, za}, {xb, yb, zb}) do
    (xb - xa) ** 2 + (yb - ya) ** 2 + (zb - za) ** 2
  end

  defp single_circuit?(map) do
    map_size(map) == 1
  end

  defp x({x, _, _}), do: x
end
