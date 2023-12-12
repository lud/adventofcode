defmodule AdventOfCode.Y23.Day12 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    [sources, counts] = String.split(line, " ")
    sources = String.graphemes(sources)
    counts = Enum.map(String.split(counts, ","), &String.to_integer/1)
    {sources, counts}
  end

  def part_one(problem) do
    problem
    |> Enum.map(&count_line/1)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.map(&expand_line/1)
    |> part_one()
  end

  defp expand_line({graphemes, counts}) do
    graphemes = :lists.flatten(Enum.intersperse(List.duplicate(graphemes, 5), "?"))
    counts = :lists.flatten(List.duplicate(counts, 5))
    {graphemes, counts}
  end

  require Record
  Record.defrecordp(:s, :s, [:brk_grp_i, :b_brk, :combis, :consumed, :prev])

  def count_line({mask, bad_counts}) do
    len = length(mask)

    countmap = bad_counts |> Enum.with_index() |> Map.new(fn {n, i} -> {i, n} end)
    states = [s(brk_grp_i: -1, b_brk: 0, combis: 1, consumed: 0, prev: ".")]
    max_index = map_size(countmap) - 1
    n_dist_bad = Enum.sum(bad_counts)

    Enum.reduce(mask, {states, len}, fn char, {states, rem_len} ->
      rem_len = rem_len - 1

      new_states =
        expand_states(states, char, countmap, max_index)
        |> combine()
        |> Enum.filter(fn
          s(consumed: tb) -> n_dist_bad - tb <= rem_len
        end)

      {new_states, rem_len}
    end)
    |> elem(0)
    |> Enum.map(fn s(combis: c) -> c end)
    |> Enum.sum()
  end

  defp combine(states) do
    states
    |> Enum.group_by(fn s(brk_grp_i: group_i, b_brk: n, prev: prev) -> {group_i, n, prev} end)
    |> Enum.map(fn {_groupby, same_states} ->
      Enum.reduce(same_states, fn s(combis: c1) = a, s(combis: c2) ->
        s(a, combis: c1 + c2)
      end)
    end)
  end

  defp expand_states(states, char, countmap, max_index) do
    Enum.flat_map(states, fn state -> expand(state, char, countmap, max_index) end)
  end

  defp expand(state, "?", countmap, max_index) do
    # choosing .
    with_dot = use_dot(state, countmap)

    # choosing #
    with_bad = use_broken(state, countmap, max_index)

    with_dot ++ with_bad
  end

  defp expand(state, "#", countmap, max_index) do
    use_broken(state, countmap, max_index)
  end

  defp expand(state, ".", countmap, _max_index) do
    use_dot(state, countmap)
  end

  defp use_broken(s(brk_grp_i: i, b_brk: n, prev: prev, consumed: tb) = state, countmap, max_index) do
    case prev do
      "#" ->
        new_amount = n + 1

        if new_amount > Map.get(countmap, i, :infinity) do
          # group too big, abandon state
          []
        else
          [s(state, b_brk: new_amount, prev: "#", consumed: tb + 1)]
        end

      "." ->
        next_index = i + 1

        if next_index > max_index do
          []
        else
          [s(state, brk_grp_i: i + 1, b_brk: 1, prev: "#", consumed: tb + 1)]
        end
    end
  end

  defp use_dot(s(brk_grp_i: i, b_brk: n, prev: prev) = state, countmap) do
    case prev do
      "#" ->
        if Map.get(countmap, i, :infinity) == n do
          [s(state, prev: ".")]
        else
          []
        end

      "." ->
        [state]
    end
  end
end
