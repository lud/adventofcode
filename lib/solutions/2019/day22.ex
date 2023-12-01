defmodule Aoe.Y19.Day22 do
  alias Aoe.Input, warn: false

  # DISCLAIMER
  #
  # This is NOT my code, is Sasa's (
  # https://github.com/sasa1977/aoc/blob/master/lib/2019/201922.ex )
  #

  @spec read_file(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input(input, _part) do
    input
    |> Enum.map(&parse_line/1)
  end

  defp parse_line("deal with increment " <> n) do
    {x, ""} = Integer.parse(n)
    {:increment, x}
  end

  defp parse_line("cut " <> n) do
    {x, ""} = Integer.parse(n)
    {:cut, x}
  end

  defp parse_line("deal into new stack") do
    :restack
  end

  import Kernel, except: [apply: 3]

  def part_one(problem) do
    deck_size = 10_007
    function = shuffle_function(deck_size, problem)
    apply(function, 2019, deck_size)
  end

  def part_two(problem) do
    deck_size = 119_315_717_514_047
    steps = 101_741_582_076_661

    inverse_shuffle(deck_size, problem)
    |> applied_many_times(steps, deck_size)
    |> apply(2020, deck_size)
  end

  defp apply({a, b}, x, deck_size), do: normalize(a * x + b, deck_size)

  defp applied_many_times(function, count, deck_size) do
    binary_digits = count |> Integer.to_string(2) |> to_charlist() |> Stream.map(&(&1 - ?0))
    functions = Stream.iterate(function, &compose(&1, &1, deck_size))

    binary_digits
    |> Enum.reverse()
    |> Stream.zip(functions)
    |> Stream.reject(fn {digit, _function} -> digit == 0 end)
    |> Stream.map(fn {_digit, function} -> function end)
    |> Enum.reduce(&compose(&1, &2, deck_size))
  end

  defp compose({ga, gb}, {fa, fb}, deck_size),
    do: {normalize(ga * fa, deck_size), normalize(ga * fb + gb, deck_size)}

  defp shuffle_function(deck_size, problem),
    do: Enum.reduce(functions(deck_size, problem), &compose(&1, &2, deck_size))

  defp inverse_shuffle(deck_size, problem) do
    functions(deck_size, problem)
    |> Stream.map(&inverse(&1, deck_size))
    |> Enum.reduce(&compose(&2, &1, deck_size))
  end

  defp functions(deck_size, problem), do: Stream.map(problem, &function(&1, deck_size))

  defp function(:restack, deck_size), do: {-1, deck_size - 1}
  defp function({:cut, n}, _deck_size), do: {1, -n}
  defp function({:increment, n}, _deck_size), do: {n, 0}

  defp inverse({a, b}, deck_size),
    do: {normalized_div(1, a, deck_size), normalized_div(-b, a, deck_size)}

  defp normalized_div(a, b, deck_size) do
    a
    |> Stream.iterate(&(&1 + deck_size))
    |> Enum.find(&(rem(&1, b) == 0))
    |> div(b)
    |> normalize(deck_size)
  end

  defp normalize(pos, deck_size) when pos < 0, do: deck_size - normalize(-pos, deck_size)
  defp normalize(pos, deck_size), do: rem(pos, deck_size)
end
