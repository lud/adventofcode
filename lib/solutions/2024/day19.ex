defmodule AdventOfCode.Solutions.Y24.Day19 do
  alias AoC.Input

  def parse(input, _part) do
    [towels, targets] = input |> Input.read!() |> String.trim() |> String.split("\n\n")

    towels = towels |> String.split([",", " "], trim: true) |> Enum.map(&{&1, byte_size(&1)})
    targets = String.split(targets, "\n", trim: true)
    {towels, targets}
  end

  def part_one({towels, targets}) do
    primitives = reduce_towels(towels)
    targets = filter_possible_targets(targets, primitives)
    length(targets)
  end

  # remove towel that can be constructed with other towels
  defp reduce_towels(towels) do
    uniqs = Enum.uniq(towels)
    true = uniqs == towels
    cases = Enum.map(towels, fn t -> {t, towels -- [t]} end)
    {_composable, primitive} = Enum.split_with(cases, fn {{text, _}, others} -> possible_target?(text, others) end)
    primitive = Enum.map(primitive, &elem(&1, 0))

    if length(towels) != length(primitive) do
      reduce_towels(primitive)
    else
      primitive
    end
  end

  defp filter_possible_targets(targets, towels) do
    # Enum.filter(targets, &possible_target?(&1, towels))
    targets
    |> Task.async_stream(&{possible_target?(&1, towels), &1}, ordered: false, timeout: :infinity)
    |> Enum.flat_map(fn
      {:ok, {true, t}} -> [t]
      {:ok, {false, _}} -> []
    end)
  end

  defp possible_target?(target, towels) do
    possible_target?(target, towels, towels)
  end

  defp possible_target?("", _, _), do: true
  defp possible_target?(_, [], _), do: false

  defp possible_target?(target, [{h, b} | t], towels) do
    sub_match? =
      case target do
        <<^h::binary-size(b), rest::binary>> ->
          possible_target?(rest, towels, towels)

        _ ->
          false
      end

    if sub_match? do
      true
    else
      possible_target?(target, t, towels)
    end
  end

  def part_two({towels, targets}) do
    primitives = reduce_towels(towels)
    targets = filter_possible_targets(targets, primitives)

    Enum.reduce(targets, 0, fn t, acc ->
      acc + count_combs(t, towels)
    end)
  end

  defp count_combs(target, towels) do
    matching_towels = Enum.filter(towels, fn {text, _} -> String.contains?(target, text) end)
    do_count(%{target => 1}, matching_towels, 0)
  end

  defp do_count(target_suffixes, _towels, count) when map_size(target_suffixes) == 0 do
    count
  end

  defp do_count(target_suffixes, towels, count) do
    new_suffixes =
      for {t, count} <- target_suffixes, {h, b} <- towels, reduce: [] do
        sufxs ->
          case t do
            <<^h::binary-size(b), rest::binary>> -> [{rest, count} | sufxs]
            _ -> sufxs
          end
      end

    target_suffixes = Enum.reduce(new_suffixes, %{}, fn {sufx, cpt}, acc -> Map.update(acc, sufx, cpt, &(&1 + cpt)) end)

    {adds, target_suffixes} = Map.pop(target_suffixes, "", 0)
    do_count(target_suffixes, towels, count + adds)
  end
end
