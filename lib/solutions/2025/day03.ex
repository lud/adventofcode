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
    init_candidate = {0, len, bank, []}

    best_candidate =
      Enum.reduce(11..0, init_candidate, fn need_remaining_digits, candidate ->
        {_index, rest_len, bank_rest, digits} = candidate
        best_candidate(bank_rest, rest_len, need_remaining_digits, digits)
      end)

    value_of(best_candidate)
  end

  # finds the highest numbers with at least `need_remaining` digits at the
  # right`
  defp best_candidate(bank, len, need_remaining, digits_acc) do
    max_index_plus_one = len - need_remaining
    {candidates, _rest} = Enum.split(bank, max_index_plus_one)

    {digit, index} =
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

    true = length(rest) == rest_len
    {index, rest_len, rest, [digit | digits_acc]}
  end

  defp value_of(candidate) do
    {_, _, _, rev_digits} = candidate
    Integer.undigits(:lists.reverse(rev_digits))
  end
end
