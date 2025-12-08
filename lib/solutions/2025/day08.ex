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
    IO.puts("""

    GO




    """)

    circuits = xyzs |> Enum.with_index() |> Map.new()

    circuits = connect_boxes(xyzs, circuits, %{}, n_pairs)

    circuits
    |> Enum.group_by(&elem(&1, 1))
    |> dbg()
    |> Enum.map(fn {_, list} -> length(list) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()

    # circuits =
    #   Enum.reduce(xyzs, circuits, fn xyz, circuits ->
    #     case Map.fetch!(circuits, xyz) do
    #       {_, true} ->
    #         circuits

    #       {_, false} ->
    #         xyz |> dbg()
    #         closest = closest(xyz, xyzs) |> dbg()
    #         {c, _} = Map.fetch!(circuits, closest)

    #         circuits
    #         |> Map.update!(closest, fn {^c, _} -> {c, true} end)
    #         |> Map.update!(xyz, fn {_, _} -> {c, true} end)
    #     end
    #   end)

    # groups = Enum.group_by(circuits, fn {_, {c, true}} -> c end) |> dbg(limit: :infinity)
    # [a, b, c | _] = sizes = Enum.map(groups, fn {_, subs} -> length(subs) end) |> Enum.sort(:desc)
    # a * b * c
  end

  defp connect_boxes(xyzs, circuits, connected, 0) do
    circuits
  end

  defp connect_boxes(xyzs, circuits, connected, n_pairs) do
    {{a, b}, connected} = connect(xyzs, connected, circuits)
    {a, b} |> IO.inspect(limit: :infinity, label: "#{n_pairs}")
    circuits = merge_circuits(circuits, a, b)
    connect_boxes(xyzs, circuits, connected, n_pairs - 1)
  end

  defp merge_circuits(circuits, xyz_a, xyz_b) do
    circ_a = Map.fetch!(circuits, xyz_a)
    circ_b = Map.fetch!(circuits, xyz_b)

    circuits =
      Map.new(circuits, fn
        {xyz, ^circ_a} -> {xyz, circ_b}
        other -> other
      end)
  end

  defp connect(xyzs, connected, _) do
    # find the closest pair not already connected
    closest_pair =
      xyzs
      |> Enum.map(fn xyz ->
        closest_pair(xyz, xyzs, Map.get(connected, xyz, []))
      end)
      |> Enum.min_by(fn {a, b, dist} -> dist end)

    {a, b, _} = closest_pair
    connected = Map.update(connected, a, [b], &[b | &1])
    connected = Map.update(connected, b, [a], &[a | &1])
    {{a, b}, connected}
  end

  defp distance({xa, ya, za}, {xb, yb, zb}) do
    :math.sqrt(
      :math.pow(xb - xa, 2) +
        :math.pow(yb - ya, 2) +
        :math.pow(zb - za, 2)
    )
  end

  defp closest_pair(a, list, exclusions) do
    {closest, dist} =
      list
      |> Enum.filter(&(&1 != a and &1 not in exclusions))
      |> Enum.map(&{&1, distance(&1, a)})
      |> Enum.sort_by(fn {_, dist} -> dist end)
      |> hd()

    {a, closest, dist}
  end

  defp closest(a, list) do
    Enum.min_by(list, fn
      ^a -> :infinity
      b -> distance(a, b)
    end)
  end

  # def part_two(problem) do
  #   problem
  # end
end
