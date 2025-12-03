defmodule AdventOfCode.Solutions.Y25.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(&Integer.digits(String.to_integer(&1)))
  end

  def part_one(banks) do
    Enum.sum_by(banks, &best_jolts/1)
  end

  defp best_jolts(digits) do
    {last, firsts} = List.pop_at(digits, -1)
    first = Enum.max(firsts) |> dbg()
    [^first | rest] = Enum.drop_while(firsts, &(&1 != first))
    second = Enum.max([last | rest])
    first * 10 + second
  end

  # def part_two(problem) do
  #   problem
  # end
end
