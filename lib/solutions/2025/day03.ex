defmodule AdventOfCode.Solutions.Y25.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&Integer.digits(String.to_integer(&1)))
  end

  def part_one(banks) do
    Enum.sum_by(banks, &best_jolts_pair/1)
  end

  defp best_jolts_pair(digits) do
    {last, firsts} = List.pop_at(digits, -1)
    first = Enum.max(firsts)
    [^first | rest] = Enum.drop_while(firsts, &(&1 != first))
    second = Enum.max([last | rest])
    first * 10 + second
  end

  def part_two([first | _] = banks) do
    len = length(first)

    banks
    # |> Enum.drop(1)
    # |> Enum.take(1)
    |> Enum.map(&best_jolts(&1, len))

    # raise "foo"
    |> Enum.sum()
  end

  defp best_jolts(bank, len) do
    init_candidates = best_indices(bank, len, 11, [])

    candidates =
      Enum.reduce(10..0, init_candidates, fn need_remaining_digits, candidates ->
        secondary_indices(candidates, need_remaining_digits)
      end)

    best_candidate(candidates)
  end

  # finds the highest numbers with at least `need_remaining` digits at the
  # right`
  defp best_indices(bank, len, need_remaining, digits_acc) do
    max_index_plus_one = len - need_remaining
    {candidates, rest} = Enum.split(bank, max_index_plus_one)

    candidates
    |> Enum.with_index()
    |> Enum.reduce({0, []}, fn {value, index}, {best, acc} ->
      case value do
        ^best -> {best, [index | acc]}
        n when n > best -> {n, [index]}
        n when n < best -> {best, acc}
      end
    end)
    |> case do
      {0, _} ->
        exit(:bad!)

      {n, indices} ->
        Enum.map(indices, fn index ->
          {_, rest} = Enum.split(bank, index + 1)
          rest_len = len - index - 1

          true = length(rest) == rest_len
          {[n | digits_acc], index, rest_len, rest}
        end)
    end
  end

  defp secondary_indices(candidates, need_remaining) do
    candidates
    |> Enum.flat_map(fn {digits, index, rest_len, bank_rest} ->
      # Possible optimization, if collected digits are the same for two
      # candidates, just keep the candidate with the lowest index
      best_indices(bank_rest, rest_len, need_remaining, digits)
    end)
  end

  defp best_candidate(candidates) do
    candidates =
      Enum.reduce(candidates, 0, fn {rev_digits, _, _, _}, acc ->
        max(acc, Integer.undigits(:lists.reverse(rev_digits)))
      end)
  end
end

# 8181 81911112111
