defmodule AdventOfCode.Y23.Day8 do
  alias AoC.Input, warn: false

  # @aaa 4276545
  # @zzz 5921370
  @aaa "AAA"
  @zzz "ZZZ"
  @aaa_end "A"
  @zzz_end "Z"

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, part) do
    [moves] = Enum.take(input, 1)
    # drop 1 instead of drop 2 because the Input.stream! will automatically
    # filter empty lines. TODO That maybe a problem for other AoC days.
    navmap = input |> Enum.drop(1) |> Map.new(&parse_nav(part, &1))
    {parse_moves(moves), navmap}
  end

  defp parse_moves(raw) do
    String.to_charlist(raw)
  end

  defp parse_nav(:part_one, raw) do
    <<tag::binary-size(3), " = (", left::binary-size(3), ", ", right::binary-size(3), ")">> = raw
    {tag, {left, right}}
  end

  defp parse_nav(:part_two, raw) do
    <<tag::binary-size(2), tag_end::binary-size(1), " = (", left::binary-size(2), left_end::binary-size(1), ", ",
      right::binary-size(2), right_end::binary-size(1), ")">> = raw

    {{tag, tag_end}, {{left, left_end}, {right, right_end}}}
  end

  def part_one({moves, navmap}) do
    count_moves_p1(@aaa, moves, moves, navmap, 0)
  end

  defp count_moves_p1(@zzz, _moves, _all_moves, _navmap, count) do
    count
  end

  defp count_moves_p1(tag, [h | t], moves, navmap, count) do
    {left, right} = Map.fetch!(navmap, tag)

    case h do
      ?L -> count_moves_p1(left, t, moves, navmap, count + 1)
      ?R -> count_moves_p1(right, t, moves, navmap, count + 1)
    end
  end

  defp count_moves_p1(tag, [], moves, navmap, count) do
    count_moves_p1(tag, moves, moves, navmap, count)
  end

  def part_two({moves, navmap}) do
    starting_tags = navmap |> Map.keys() |> Enum.filter(fn {_, ending} -> ending == @aaa_end end)

    end_counts = starting_tags |> Enum.map(fn tag -> find_exit_count(tag, moves, moves, navmap, 0) end)

    Enum.reduce(end_counts, fn a, b -> trunc(lcm(a, b)) end)
    # end_positions |> dbg()
    # new_tags = end_positions |> Enum.map(fn {_, {endtag, _, []}} -> endtag end)
    # new_tags |> dbg()
    # new_tags |> Enum.map(fn tag -> {tag, find_exit_count(tag, moves, moves, navmap, 0)} end)
    # new_ends = end_positions |> Enum.map(fn {_, {endtag, _, []}} -> endtag end)
    # new_ends |> dbg()
    # count_moves_p2(starting_tags, moves, moves, navmap, 0)
  end

  defp find_exit_count({_, @zzz_end} = tag, moves, _all_moves, _navmap, count) do
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

  defp count_moves_p2(current_tags, [h | t], moves, navmap, count) do
    count |> IO.inspect(label: ~S/count/)

    if found_exit?(current_tags) do
      count
    else
      new_tags = Enum.map(current_tags, fn tag -> Map.fetch!(navmap, tag) |> fetch_next(h) end)
      count_moves_p2(new_tags, t, moves, navmap, count + 1)
    end
  end

  defp count_moves_p2(current_tags, [], moves, navmap, count) do
    count_moves_p2(current_tags, moves, moves, navmap, count)
  end

  defp found_exit?(tags) do
    Enum.all?(tags, fn {tag, ending} -> ending == @zzz_end end)
  end

  defp fetch_next({left, right}, ?L), do: left
  defp fetch_next({left, right}, ?R), do: right

  defp gcd(a, 0), do: a
  defp gcd(0, b), do: b
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(0, 0), do: 0
  defp lcm(a, b), do: a * b / gcd(a, b)
end
