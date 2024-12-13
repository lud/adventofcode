defmodule AdventOfCode.Solutions.Y24.Day13 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_machine/1)
  end

  defp parse_machine(lines) do
    [a, b, p] = String.split(lines, "\n")
    a = parse_ints(a)
    b = parse_ints(b)
    p = parse_ints(p)
    {a, b, p}
  end

  @re_ints ~r/\d+/
  defp parse_ints(line) do
    @re_ints
    |> Regex.scan(line)
    |> :lists.flatten()
    |> Enum.map(&String.to_integer/1)
    |> then(fn [a, b] -> {a, b} end)
  end

  def part_one(machines) do
    Enum.sum_by(machines, &token_price/1)
  end

  def part_two(machines) do
    offset = 10_000_000_000_000

    Enum.sum_by(machines, fn m ->
      {a, b, {xp, yp}} = m
      m = {a, b, {xp + offset, yp + offset}}
      token_price(m)
    end)
  end

  defp token_price(machine) do
    {{xa, ya}, {xb, yb}, {xp, yp}} = machine
    base = xa * yb - ya * xb
    af = (xp * yb - yp * xb) / base
    bf = (xa * yp - ya * xp) / base
    a = trunc(af)
    b = trunc(bf)

    if a == af && b == bf, do: a * 3 + b, else: 0
  end
end
