defmodule AdventOfCode.Solutions.Y19.Day16 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.read!() |> String.trim() |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  def part_one(digits, n_phases \\ 100) do
    size = length(digits)

    1..n_phases
    |> Enum.reduce(digits, fn _, digits -> apply_fft(digits, size) end)
    |> Enum.take(8)
    |> Integer.undigits()
  end

  defp apply_fft(digits, size) do
    # on each digit index, the first nth-1 digits are multiplied by zero, so for
    # each digit we will only consider the remaining ones

    {[], new_digits} =
      Enum.reduce(1..size, {digits, _new_digits = []}, fn
        offset, {[_ | t] = digits, new_digits} ->
          val = value_of(digits, offset, _pattern_repeats = offset, 0)
          new_digits = [val | new_digits]
          {t, new_digits}
      end)

    :lists.reverse(new_digits)
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

  def part_two(digits, _ \\ nil) do
    # Part two has a simplification
    #
    # We assume that the signal offset will ask us to find a singal position in
    # the second half of the final signal.
    #
    # So we can discard the first half of the giant inputs at each step,
    # because:
    # * each digit index is only dependent on the greater digit indexes, as each
    #   beginning is multiplied by zero (this is in part 1)
    # * in part 2 we will only look for numbers in the second half
    #
    #
    # Another observation (I was helped to figure it out) is that the nth digit
    # of the new iteration is equal to the nth 0..n digits of the previous
    # iteration.
    #
    # IT DOES ONLY WORK FOR THE 2ND HALF OF THE SIGNAL
    #
    # Example from the input
    #
    #    Input signal: 12345678
    #
    #    1*1  + 2*0  + 3*-1 + 4*0  + 5*1  + 6*0  + 7*-1 + 8*0  = 4 1*0  + 2*1  +
    #    3*1  + 4*0  + 5*0  + 6*-1 + 7*-1 + 8*0  = 8 1*0  + 2*0  + 3*1  + 4*1  +
    #    5*1  + 6*0  + 7*0  + 8*0  = 2 1*0  + 2*0  + 3*0  + 4*1  + 5*1  + 6*1  +
    #    7*1  + 8*0  = 2 1*0  + 2*0  + 3*0  + 4*0  + 5*1  + 6*1  + 7*1  + 8*1  =
    #    6 1*0  + 2*0  + 3*0  + 4*0  + 5*0  + 6*1  + 7*1  + 8*1  = 1 1*0  + 2*0
    #    + 3*0  + 4*0  + 5*0  + 6*0  + 7*1  + 8*1  = 5 1*0  + 2*0  + 3*0  + 4*0
    #    + 5*0  + 6*0  + 7*0  + 8*1  = 8
    #
    # The last digit (bottom line) is 8.
    #
    # 2nd last digit was 7, we add 8 => 15 => mod(10) => 5, the new digit is 5

    # 3rd last digit was 6, we add 8 + 7 => 15 + 6 => 21 => mod(10) => 1
    #
    # After phase 1: 48226158 (from the rules)
    #
    # it ends by 158.
    #
    # This will not work for the first half of the input because the beginning
    # of the pattern does not allow that. After the half, the pattern is only 1
    # for the digits we want.
    #
    # This is another reason why we do not need to compute numbers before the
    # offset

    offset = digits |> Enum.take(7) |> Integer.undigits()
    digits = Enum.flat_map(1..10000, fn _ -> digits end) |> Enum.drop(offset)

    1..100
    |> Enum.reduce(digits, fn _, digits -> apply_fft_p2(digits) end)
    |> Enum.take(8)
    |> Integer.undigits()
  end

  defp apply_fft_p2(digits) do
    # `prev` is the previous sum without applying modulo
    {_, new_digits} =
      List.foldr(digits, {0, []}, fn digit, {prev, new_digits} ->
        next = rem(prev + digit, 10)
        {next, [next | new_digits]}
      end)

    new_digits
  end
end
