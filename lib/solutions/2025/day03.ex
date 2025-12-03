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
    Enum.sum_by(banks, &best_jolts(&1, len))
  end

  defp best_jolts(bank, len) do
    init_candidate = {len, bank, 0}

    {_, _, jolts} =
      Enum.reduce(11..0//-1, init_candidate, fn need_remaining_digits, candidate ->
        {rest_len, bank_rest, jolts} = candidate
        best_candidate(bank_rest, rest_len, need_remaining_digits, jolts)
      end)

    jolts
  end

  defp best_candidate(bank, len, need_remaining_digits, jolts) do
    max_index_plus_one = len - need_remaining_digits
    {candidates, _rest} = Enum.split(bank, max_index_plus_one)

    {value, index} =
      candidates
      |> Enum.with_index()
      |> Enum.reduce({0, 0}, fn {value, index}, {best_val, best_index} ->
        case value do
          n when n > best_val -> {n, index}
          _ -> {best_val, best_index}
        end
      end)

    {_, rest} = Enum.split(bank, index + 1)
    rest_len = len - index - 1
    {rest_len, rest, jolts * 10 + value}
  end
end
