defmodule AdventOfCode.Y23.Day8 do
  alias AoC.Input, warn: false

  # @aaa 4276545
  # @zzz 5921370
  @aaa "AAA"
  @zzz "ZZZ"

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

  defp parse_nav(<<node::binary-size(3), " = (", left::binary-size(3), ", ", right::binary-size(3), ")">>) do
    {node, {left, right}}
  end

  def part_one({moves, navmap}) do
    count_moves(@aaa, moves, moves, navmap, 0)
  end

  defp count_moves(@zzz, _moves, _all_moves, _navmap, count) do
    count
  end

  defp count_moves(tag, [h | t], moves, navmap, count) do
    {left, right} = Map.fetch!(navmap, tag)

    case h do
      ?L -> count_moves(left, t, moves, navmap, count + 1)
      ?R -> count_moves(right, t, moves, navmap, count + 1)
    end
  end

  defp count_moves(tag, [], moves, navmap, count) do
    count_moves(tag, moves, moves, navmap, count)
  end

  # def part_two(problem) do
  #   problem
  # end
end
