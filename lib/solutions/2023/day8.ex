defmodule AdventOfCode.Solutions.Y23.Day8 do
  alias AoC.Input, warn: false

  # @aaa 4276545
  # @zzz 5921370
  @aa 16705

  @end_a ?A
  @end_z ?Z

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    [moves] = Enum.take(input, 1)
    # drop 1 instead of drop 2 because the Input.stream! will automatically
    # filter empty lines. TODO That maybe a problem for other AoC days.
    navmap = input |> Enum.drop(1) |> Map.new(&parse_nav/1)
    {parse_moves(moves), navmap}
  end

  defp parse_moves(raw) do
    String.to_charlist(raw)
  end

  defp parse_nav(raw) do
    <<tag::16, tag_end, " = (", left::16, left_end, ", ", right::16, right_end, ")">> = raw

    {{tag, tag_end}, {{left, left_end}, {right, right_end}}}
  end

  def part_one({moves, navmap}) do
    find_exit_count({@aa, @end_a}, moves, moves, navmap, 0)
  end

  def part_two({moves, navmap}) do
    navmap
    |> Map.keys()
    |> Enum.filter(fn {_, ending} -> ending == @end_a end)
    |> Enum.map(fn tag -> find_exit_count(tag, moves, moves, navmap, 0) end)
    |> Enum.reduce(fn a, b -> trunc(lcm(a, b)) end)
  end

  defp find_exit_count({_, @end_z}, _moves, _all_moves, _navmap, count) do
    count
  end

  defp find_exit_count(tag, [h | t], moves, navmap, count) do
    {left, right} = Map.fetch!(navmap, tag)

    case h do
      ?L -> find_exit_count(left, t, moves, navmap, count + 1)
      ?R -> find_exit_count(right, t, moves, navmap, count + 1)
    end
  end

  defp find_exit_count(tag, [], moves, navmap, count) do
    find_exit_count(tag, moves, moves, navmap, count)
  end

  defp gcd(a, 0), do: a
  defp gcd(0, b), do: b
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(0, 0), do: 0
  defp lcm(a, b), do: a * b / gcd(a, b)
end
