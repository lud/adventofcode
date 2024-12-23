defmodule AdventOfCode.Solutions.Y24.Day23 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.stream!(trim: true) |> Enum.map(fn <<a, b, ?-, c, d>> -> {<<a, b>>, <<c, d>>} end)
  end

  def part_one(problem) do
    network = build_network(problem)

    ts =
      Enum.reduce(network, %{}, fn
        {{"t" <> _ = a, b}, _}, acc -> Map.update(acc, a, [b], &[b | &1])
        {{a, "t" <> _ = b}, _}, acc -> Map.update(acc, b, [a], &[a | &1])
        _, acc -> acc
      end)

    for {t, siblings} <- ts, a <- siblings, b <- siblings, a != b, link?(network, a, b), reduce: %{} do
      acc -> Map.put_new(acc, Enum.sort([t, a, b]), true)
    end
    |> Enum.count()
  end

  defp build_network(links) do
    Map.new(links, fn {a, b} -> {{min(a, b), max(a, b)}, true} end)
  end

  defp link?(network, a, b) when a > b, do: link?(network, b, a)
  defp link?(_, a, a), do: raise("autolink")
  defp link?(network, a, b), do: is_map_key(network, {a, b})

  def part_two(problem) do
    network = build_network(problem)

    all_names =
      Enum.flat_map(network, fn {{a, b}, _} -> [a, b] end)
      |> Enum.sort()
      |> Enum.dedup()
      |> dbg()

    subnets = Enum.map(all_names, &[&1])

    best = expand_loop(subnets, all_names, network)
    Enum.join(best, ",")
  end

  defp expand_loop([last_subnet], _, _) do
    last_subnet
  end

  defp expand_loop(subnets, all_names, network) do
    subnets = expand_subnets(subnets, all_names, network)
    expand_loop(subnets, all_names, network)
  end

  defp expand_subnets(subnets, all_names, network) do
    Enum.flat_map(subnets, fn subnet ->
      news = Enum.filter(all_names, &(&1 not in subnet))

      Enum.flat_map(news, fn new ->
        if Enum.all?(subnet, fn pc -> link?(network, pc, new) end) do
          [insert(subnet, new)]
        else
          []
        end
      end)
    end)
    |> tap(&IO.inspect(length(&1), label: "len before"))
    |> Enum.uniq()
    |> tap(&IO.inspect(length(&1), label: "len after"))
  end

  defp connected_from(list, pc, network) do
    Enum.filter(list, &link?(network, pc, &1))
  end

  defp insert([h | t], c) when c < h, do: [c, h | t]
  defp insert([h | t], c) when c > h, do: [h | insert(t, c)]
  defp insert([], c), do: [c]
end
