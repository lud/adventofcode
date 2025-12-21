defmodule AdventOfCode.Solutions.Y19.Day16 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.read!() |> String.trim() |> String.to_integer() |> Integer.digits()
  end

  @base_pattern [0, 1, 0, -1]

  def part_one(digits, n_phases \\ 100) do
    size = length(digits)

    1..n_phases
    |> Enum.reduce(digits, fn i, digits ->
      IO.puts("phase: #{i}")
      _digits = apply_fft(digits, size)
    end)
    |> Enum.take(8)
    |> Integer.undigits()
  end

  defp apply_fft(digits, size) do
    digits
    |> Enum.with_index(1)
    |> Enum.map(fn {_, pattern_repeats} ->
      if rem(pattern_repeats, 100) == 0 do
        pattern_repeats |> IO.inspect(limit: :infinity, label: "pattern_repeats")
      end

      value_of(digits, 1, pattern_repeats, 0)
      # |> IO.inspect(limit: :infinity, label: "digit #{pattern_repeats}")
    end)
  end

  # pattern_repeats the the digit we are trying to compute, which determines the
  # pattern repetitions
  defp value_of([h | t], nth_digit, pattern_repeats, acc) do
    # IO.write("#{h}*#{nth_pattern(nth_digit, pattern_repeats)} + ")
    acc = acc + h * nth_pattern(nth_digit, pattern_repeats)
    value_of(t, nth_digit + 1, pattern_repeats, acc)
  end

  defp value_of([], _nth_digit, _pattern_repeats, acc) do
    v = rem(abs(acc), 10)
    # v |> IO.inspect(limit: :infinity, label: "=>")
    v
  end

  def nth_pattern(nth_digit, pattern_repeats) do
    # if nth_digit is `1` we will take the first item of the list, so actually
    # removing the first item of the pattern (as in the rules) counterbalances
    # the need to have modulo==0 for the numbers, so the remainder is directly
    # the correct position

    # nth_digit |> dbg()
    # pattern_repeats |> dbg()
    pattern_length = 4 * pattern_repeats
    # pattern_length |> dbg()

    # if nth_digit=1, pattern_repeats=1
    #     pattern is (0),[1],0,-1
    #     we want 1
    # if nth_digit=1, pattern_repeats=2
    #     pattern is (0),[0],1,1,0,0,-1,-1
    #     we want 0
    # if nth_digit=1, pattern_repeats=3
    #     pattern is (0),[0],0,1,1,1,0,0,0,-1,-1,-1
    #     we want 1
    # if nth_digit=4, pattern_repeats=1
    #     pattern is (0),1,0,-1,[0]
    #     we want 1

    # if nth_digit=5, pattern_repeats=1
    #     pattern is (0),1,0,-1,0,[1],0,-1
    #     we want 1
    # if nth_digit=5, pattern_repeats=2
    #     pattern is (0),0,1,1,0,[0],-1,-1,0,0
    #     we want 0
    # if nth_digit=5, pattern_repeats=3
    #     pattern is (0),0,0,1,1,[1],0,0,0,-1,-1,-1,0,0,0
    #     we want 1

    pattern_index = rem(nth_digit, pattern_length)
    # pattern_index |> dbg()

    cond do
      pattern_repeats > pattern_index -> 0
      pattern_repeats * 2 > pattern_index -> 1
      pattern_repeats * 3 > pattern_index -> 0
      pattern_repeats * 4 > pattern_index -> -1
    end
  end

  # |> tap(
  #   &(&1
  #     |> Integer.undigits()
  #     |> Integer.to_string()
  #     |> String.pad_leading(32, "0")
  #     |> IO.puts())
  # )

  defp make_pattern(size, nth_digit) do
    [h | t] = full_pattern = Enum.flat_map(@base_pattern, fn d -> List.duplicate(d, nth_digit) end)
    # The first repetition must ignore the first number
    Stream.concat(t, Stream.cycle(full_pattern))
  end

  # def part_two(digits) do
  #   size = length(digits)
  #   digits = Enum.flat_map(1..10000, fn _ -> digits end)
  #   size = size * 10000
  #   true = size == length(digits)

  #   1..100
  #   |> Enum.reduce(digits, fn i, digits ->
  #     IO.puts("phase: #{i}")
  #     apply_fft(digits, size)
  #   end)
  #   |> Enum.take(8)
  #   |> Integer.undigits()
  # end
end
