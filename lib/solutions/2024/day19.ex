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

  # Optimization, in order to count possible sub patterns only once for each
  # suffix, we need to keep an ordered list of suffixes with the longest
  # suffixes on top. So when that longest suffix is cut with a towel, the
  # remainder can be found in the shorter suffixes and the count can be added to
  # it. When we will arrive at that shorter suffix, all longer suffixes that
  # could lead to it will have been checked.

  defp count_combinations(target, towels) do
    possible_towels = Enum.filter(towels, fn {text, _} -> String.contains?(target, text) end)
    do_count([{target, 1}], possible_towels)
  end

  defp do_count([{"", count}], _) do
    count
  end

  defp do_count([longest | target_suffixes], towels) do
    {target_suffix, suffix_score} = longest

    new_suffixes =
      Enum.flat_map(towels, fn {h, b} ->
        case target_suffix do
          <<^h::binary-size(b), rest::binary>> -> [{rest, suffix_score}]
          _ -> []
        end
      end)

    target_suffixes = insert_all(target_suffixes, new_suffixes)

    do_count(target_suffixes, towels)
  end

  defp insert_all(target_suffixes, [h | t]), do: insert_all(insert(target_suffixes, h), t)
  defp insert_all(target_suffixes, []), do: target_suffixes

  defp insert([{longest, _} = top | t], {text, _} = new) when byte_size(text) < byte_size(longest) do
    [top | insert(t, new)]
  end

  defp insert([{same, count} | t], {same, add}) do
    [{same, count + add} | t]
  end

  defp insert(t, new) do
    [new | t]
  end
end
