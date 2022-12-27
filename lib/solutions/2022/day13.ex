defmodule Aoe.Y22.Day13 do
  alias Aoe.Input

  def read_file!(file, _part) do
    Input.read!(file)
  end

  def parse_input!(input, _part) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.flat_map(&parse_line/1)
  end

  defp parse_line("") do
    []
  end

  defp parse_line(text) do
    [Jason.decode!(text)]
  end

  def part_one(packets) do
    packets
    |> Enum.chunk_every(2)
    |> Enum.map(&compare/1)
    |> Enum.with_index(1)
    |> Enum.filter(fn {order, _} -> order == :lt end)
    |> Enum.reduce(0, fn {_, index}, acc -> acc + index end)
  end

  def part_two(packets) do
    [[[2]], [[6]] | packets]
    |> Enum.sort(__MODULE__)
    |> Enum.with_index(1)
    |> Enum.filter(fn {p, _} -> p == [[6]] or p == [[2]] end)
    |> case(do: ([{_, a}, {_, b}] -> a * b))
  end

  def compare([left, right]) do
    compare(left, right)
  end

  def compare([a | as], [b | bs]) do
    case compare(a, b) do
      :eq -> compare(as, bs)
      other -> other
    end
  end

  def compare([], []) do
    :eq
  end

  def compare([], [_ | _]) do
    :lt
  end

  def compare([_ | _], []) do
    :gt
  end

  def compare(a, b) when is_integer(a) and is_integer(b) do
    cond do
      a < b -> :lt
      a > b -> :gt
      a == b -> :eq
    end
  end

  def compare(a, b) when is_list(a) and is_integer(b) do
    compare(a, [b])
  end

  def compare(a, b) when is_integer(a) and is_list(b) do
    compare([a], b)
  end
end
