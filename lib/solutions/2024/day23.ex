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
  defp link?(_, a, a), do: raise("autolink #{a}")
  defp link?(network, a, b), do: is_map_key(network, {a, b})

  def part_two(problem) do
    # Look at bjorns solution, it's more straightforward and faster.

    network = build_network(problem)
    all_names = Enum.flat_map(network, fn {{a, b}, _} -> [a, b] end) |> Enum.uniq()
    subnets = build_initial(all_names, []) |> Map.new()
    {best, _} = loop_expand(subnets, network)
    Enum.map_join(best, ",", fn {k, _true} -> k end)
  end

  defp build_initial([h | t], acc) do
    subnet = %{h => true}
    candidates = Map.new(t, &{&1, true})
    build_initial(t, [{subnet, candidates} | acc])
  end

  defp build_initial([], acc) do
    acc
  end

  defp loop_expand(subnets, network) do
    subnets = expand_subnets(subnets, network)

    case map_size(subnets) do
      1 -> subnets |> Map.to_list() |> hd()
      _ -> loop_expand(subnets, network)
    end
  end

  defp expand_subnets(subnets, network) do
    Enum.reduce(subnets, %{}, fn sub, acc -> expand_subnet(sub, acc, network) end)
  end

  defp expand_subnet({subnet, candidates}, acc, network) do
    Enum.reduce(candidates, acc, fn {new, _true}, acc ->
      sub_with_new = Map.put(subnet, new, true)

      with false <- Map.has_key?(acc, sub_with_new),
           true <- Enum.all?(subnet, fn {pc, _true} -> link?(network, pc, new) end) do
        # remove candidates that will not be linked to the new node in subset
        new_candidates = Map.filter(candidates, fn {k, _true} -> k != new && link?(network, k, new) end)
        Map.put(acc, sub_with_new, new_candidates)
      else
        _ -> acc
      end
    end)
  end
end
