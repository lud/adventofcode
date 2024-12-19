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

  # remove towels that can be constructed with other towels
  defp reduce_towels(towels) do
    case Enum.split_with(towels, fn {text, _} = t -> possible_target?(text, towels -- [t]) end) do
      {[], all_primitives} -> all_primitives
      {_composable, primitives} -> reduce_towels(primitives)
    end
  end

  defp filter_possible_targets(targets, towels) do
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
        <<^h::binary-size(b), rest::binary>> -> possible_target?(rest, towels, towels)
        _ -> false
      end

    sub_match? || possible_target?(target, t, towels)
  end

  def part_two({towels, targets}) do
    primitives = reduce_towels(towels)

    targets
    |> filter_possible_targets(primitives)
    |> Task.async_stream(&count_combinations(&1, towels), ordered: false, timeout: :infinity)
    |> Enum.reduce(0, fn {:ok, n}, acc -> acc + n end)
  end

  defp count_combinations(target, towels) do
    possible_towels = Enum.filter(towels, fn {text, _} -> String.contains?(target, text) end)
    do_count(%{target => 1}, possible_towels, 0)
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

    {target_suffixes, finished_count} =
      Enum.reduce(new_suffixes, {%{}, 0}, fn
        {"", cpt}, {map, finished_count} -> {map, finished_count + cpt}
        {sufx, cpt}, {map, finished_count} -> {Map.update(map, sufx, cpt, &(&1 + cpt)), finished_count}
      end)

    do_count(target_suffixes, towels, count + finished_count)
  end
end
