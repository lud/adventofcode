defmodule AdventOfCode.Solutions.Y24.Day22 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.stream!(trim: true) |> Enum.map(&String.to_integer/1)
  end

  def part_one(problem) do
    problem
    |> Enum.map(&next_number(&1, 2000))
    |> Enum.sum()
  end

  defp next_number(n, i) when i > 0 do
    next_number(next_number(n), i - 1)
  end

  defp next_number(n, 0) do
    n
  end

  defp next_number(num) do
    num = prune(mix(num, num * 64))
    num = prune(mix(num, div(num, 32)))
    num = prune(mix(num, num * 2048))
    num
  end

  defp mix(a, b), do: Bitwise.bxor(a, b)
  defp prune(n), do: Integer.mod(n, 16_777_216)

  def part_two(problem) do
    parent = self()

    problem
    |> Enum.map(fn monkey_seed ->
      spawn_link(fn -> send(parent, compute_sequences(compute_future(monkey_seed))) end)
    end)
    |> Stream.map(fn _ -> receive(do: (seq -> seq)) end)
    |> Enum.reduce(fn seqs1, seq2 -> Map.merge(seqs1, seq2, fn _, v1, v2 -> v1 + v2 end) end)
    |> Enum.reduce(0, fn {_, v}, best -> max(best, v) end)
  end

  # def part_two(problem) do
  #   all_sequences = Enum.map(problem, fn monkey_seed -> monkey_seed |> compute_future() |> compute_sequences() end)
  #   merged = Enum.reduce(all_sequences, fn seqs1, seq2 -> Map.merge(seqs1, seq2, fn _, v1, v2 -> v1 + v2 end) end)
  #   Enum.reduce(merged, 0, fn {_, v}, best -> max(best, v) end)
  # end

  defp compute_future(monkey_seed) do
    Enum.scan(1..2000, {monkey_seed, unit_part(monkey_seed), nil}, fn _, {prev_secret, prev_unit, _} ->
      next_secret = next_number(prev_secret)
      unit = unit_part(next_secret)
      {next_secret, unit, unit - prev_unit}
    end)
  end

  defp compute_sequences(monkey_future, prev \\ [], acc \\ %{})

  defp compute_sequences([h | monkey_future], [c, b, a | prev], acc) do
    {_secret, price, d} = h
    <<seq::integer-20>> = <<a::5, b::5, c::5, d::5>>
    acc = Map.put_new(acc, seq, price)
    compute_sequences(monkey_future, [d, c, b, a | prev], acc)
  end

  defp compute_sequences([], _prev, acc) do
    acc
  end

  # prefill the previous
  defp compute_sequences([{_, _, seqn} | monkey_future], prev, acc) do
    compute_sequences(monkey_future, [seqn | prev], acc)
  end

  # returns the rightmost digit of number
  defp unit_part(number) do
    rem(number, 10)
  end
end
