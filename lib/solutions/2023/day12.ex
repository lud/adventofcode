defmodule AdventOfCode.Y23.Day12 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    Enum.map(input, &parse_line/1)
  end

  defp parse_line(line) do
    [sources, counts] = String.split(line, " ")
    sources = String.to_charlist(sources)
    counts = counts |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
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

  defp expand_line({sources, counts}) do
    sources =
      :lists.flatten([
        sources,
        ??,
        sources,
        ??,
        sources,
        ??,
        sources,
        ??,
        sources
      ])

    counts = :lists.flatten([counts, counts, counts, counts, counts])
    {sources, counts}
  end

  def count_line_old({sources, counts} = line) do
    line |> IO.inspect(label: ~S/line/)
    n_sources = length(sources)
    known_broken = Enum.sum(counts) |> IO.inspect(label: ~S/known broken/)
    # we know the groups of contiguous broken sources we want the groups of the
    # valid sources. They are at least one in between each broken group, and maybe 0 or more before the groups and after the groups
    [1 | ones] = contiguous = Enum.map(counts, fn _ -> 1 end)
    ok_sources_base = [0 | ones] ++ [0]

    max_group_index = length(ok_sources_base) - 1

    # now for each broken source, we add 1 to each of the ok groups, givig more
    # and more combinations
    n_distrib = n_sources - known_broken - Enum.sum(ok_sources_base)
    n_distrib |> IO.inspect(label: ~S/n_distrib/)

    # 1..n_distrib
    # |> Stream.map(fn _ -> ok_sources_base end)
    # |> Stream.map(fn ok_sources_groups ->

    # end)

    base_stream = [ok_sources_base]
    dist_range = 0..(n_distrib - 1)//1
    dist_range |> IO.inspect(label: ~S/dist_range/)

    stream =
      Enum.reduce(dist_range, base_stream, fn _, stream -> distribute_to_stream(stream, max_group_index) end)

    stream
    # |> Stream.map(&IO.inspect(&1, label: "ok counts"))
    |> Stream.map(&build_sources(&1, counts))
    |> Stream.map(fn built ->
      if length(built) != n_sources do
        sources |> dbg()
        built |> dbg()
        raise "invalid build"
      end

      # built |> IO.inspect(label: ~S/built/)
      built
    end)
    # |> Stream.filter(&match_mask(&1, sources))
    |> Stream.filter(fn built ->
      IO.puts("-----------")
      matches = match_mask(built, sources)
      built |> IO.inspect(label: ~S/--built/)
      sources |> IO.inspect(label: ~S/sources/)
      matches |> IO.inspect(label: ~S/matches/)
      IO.puts("-----------")

      matches
    end)
    |> Enum.count()
    |> IO.inspect(label: ~S/count()/)
  end

  def count_line({sources, counts} = line) do
    IO.puts("--------")
    {sources, counts} |> IO.inspect(label: ~S/sources, counts/)
    freqs = Enum.frequencies(sources)
    n_questions = Map.get(freqs, ??, 0)
    n_questions |> IO.inspect(label: ~S/n_questions/)
    n_known_broken = Map.get(freqs, ?#, 0)
    n_known_broken |> IO.inspect(label: ~S/n_known_broken/)
    n_total_broken = Enum.sum(counts)
    n_total_broken |> IO.inspect(label: ~S/n_total_broken/)
    n_dist_broken = n_total_broken - n_known_broken
    n_dist_broken |> IO.inspect(label: ~S/n_dist_broken/)
    qm_indices = sources |> Enum.with_index() |> Enum.filter(fn {c, _} -> c == ?? end) |> Enum.map(fn {_, i} -> i end)
    qm_indices |> IO.inspect(label: ~S/qm_indices/)

    init = [{sources, n_dist_broken}]
    reduce_range = n_questions..1//-1
    reduce_range |> IO.inspect(label: ~S/reduce_range/)

    Enum.reduce(reduce_range, init, fn _n, acc ->
      acc |> IO.inspect(label: ~S/acc/)

      Enum.flat_map(acc, fn
        {sources, 0} ->
          [{replace_first_qm(sources, ?.), 0}]

        {sources, n_dist_broken} ->
          [{replace_first_qm(sources, ?.), n_dist_broken}, {replace_first_qm(sources, ?#), n_dist_broken - 1}]
      end)
    end)
    |> Enum.map(fn {built, _} -> built end)
    |> Stream.filter(fn built ->
      IO.puts("-----------")
      matches = match_mask(built, sources)
      built |> IO.inspect(label: ~S/--built/)
      sources |> IO.inspect(label: ~S/sources/)
      matches |> IO.inspect(label: ~S/matches/)
      IO.puts("-----------")

      matches
    end)
    |> Enum.count()
  end

  defp replace_first_qm([?? | t], c), do: [c | t]
  defp replace_first_qm([h | t], c), do: [h | replace_first_qm(t, c)]

  defp build_sources([ok | ok_sources], [br | broken_sources]) do
    List.duplicate(?., ok) ++ List.duplicate(?#, br) ++ build_sources(ok_sources, broken_sources)
  end

  defp build_sources([ok], []) do
    List.duplicate(?., ok)
  end

  defp match_mask([_ | a], [?? | b]) do
    match_mask(a, b)
  end

  defp match_mask([?. | a], [?. | b]) do
    match_mask(a, b)
  end

  defp match_mask([?# | a], [?# | b]) do
    match_mask(a, b)
  end

  defp match_mask([_ | a], [_ | b]) do
    false
  end

  defp match_mask([], []) do
    true
  end

  defp distribute_to_stream(stream, max_group_index) do
    Enum.flat_map(stream, fn group ->
      Enum.map(0..max_group_index, fn i -> List.update_at(group, i, &(&1 + 1)) end)
    end)
    |> Enum.uniq()
  end
end
