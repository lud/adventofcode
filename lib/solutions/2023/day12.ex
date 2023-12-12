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

    # |> then(&{&1, :fail})
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

  def count_line_enum({sources, counts} = line) do
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
      Enum.reduce(dist_range, base_stream, fn _, stream -> distribute_to_enum(stream, max_group_index) end)

    stream
    # |> Stream.map(&IO.inspect(&1, label: "ok counts"))
    |> Stream.map(&build_sources(&1, counts))
    |> Stream.map(fn built ->
      if length(built) != n_sources do
        sources
        built
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

    base_stream = [ok_sources_base]
    dist_range = 0..(n_distrib - 1)//1
    dist_range |> IO.inspect(label: ~S/dist_range/)

    max_ok_group = count_max_series(sources, ?.)
    max_broken_group = count_max_series(sources, ?#)

    max_ok_group |> IO.inspect(label: ~S/max_ok_group/)
    max_broken_group |> IO.inspect(label: ~S/max_broken_group/)

    stream =
      Enum.reduce(dist_range, base_stream, fn _, stream ->
        stream
        |> distribute_to_stream(max_group_index)
        |> Stream.filter(fn ok_groups -> Enum.all?(ok_groups, fn g -> g <= max_ok_group end) end)
        |> Enum.uniq()
        |> IO.inspect(label: ~S/binding()/)

        # |> tap(&IO.inspect(length(&1), label: ~S/length/))
      end)

    stream
    # |> Stream.map(&IO.inspect(&1, label: "ok counts"))
    |> Stream.map(&build_sources(&1, counts))
    # |> Stream.map(fn built ->
    #   if length(built) != n_sources do
    #     sources |> dbg()
    #     built |> dbg()
    #     raise "invalid build"
    #   end

    #   # built |> IO.inspect(label: ~S/built/)
    #   built
    # end)
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
  end

  defp count_max_series(sources, kind, acc \\ 0, max_acc \\ 0)

  defp count_max_series([h | t], kind, acc, max_acc) when h == kind or h == ?? do
    count_max_series(t, kind, acc + 1, max_acc)
  end

  defp count_max_series([_ | t], kind, acc, max_acc) do
    count_max_series(t, kind, 0, max(max_acc, acc))
  end

  defp count_max_series([], kind, acc, max_acc) do
    max(max_acc, acc)
  end

  defp take_maybe_broken(rest, 0), do: {:ok, rest}

  # def count_line({[?#|_]=sources, [n|t]=counts} ) do
  #   sources = List.duplicate(?#, n) ++ Enum.drop(sources, n)
  #   _count_line({sources,counts})
  # end
  # def count_line(line) do

  #   _count_line(line)
  # end

  def count_line_stream({sources, counts} = line) do
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
    dist_range = n_questions..1//-1
    dist_range |> IO.inspect(label: ~S/dist_range/)

    max_broken_group = count_max_series(sources, ?#)
    max_broken_group |> IO.inspect(label: ~S/max_broken_group/)

    keep_group = fn {built, _} ->
      current_maxs = rebuild_counts(built, [])
      valid = Enum.all?(current_maxs, fn g -> g <= max_broken_group end)
      ok? = valid && match_mask(built, sources)
      # sources |> IO.inspect(label: ~S/sources/)
      if ok? do
        #   built |> IO.inspect(label: ~S/--valid/)
      else
        max_broken_group |> IO.inspect(label: ~S/max_broken_group/)
        built |> IO.inspect(label: ~S/invalid/)
        raise "why does this never happen"
      end

      ok?
    end

    stream =
      Enum.reduce(dist_range, init, fn remaining_qms, stream ->
        remaining_qms |> IO.inspect(label: ~S/remaining_qms/)
        # Enum.to_list(stream) |> IO.inspect(label: ~S/before/)
        Stream.flat_map(stream, fn
          {sources, :done} ->
            [{sources, :done}]

          {sources, 0} ->
            [{replace_all_qms(sources, ?.), :done}]
            |> Enum.filter(keep_group)

          {sources, needed_broken} when needed_broken > remaining_qms ->
            []

          {sources, needed_broken} ->
            # sources |> IO.inspect(label: ~S/sources/)
            [
              {replace_first_qm(sources, ?.), needed_broken},
              {replace_first_qm(sources, ?#), needed_broken - 1}
            ]

            # |> Enum.filter(keep_group)
        end)

        # |> Stream.filter(keep_group)
      end)

    # # Enum.reduce(dist_range, init, fn _n, acc ->
    # #   # acc |> IO.inspect(label: ~S/acc/)

    # #   Enum.flat_map(acc, fn
    # #     {sources, 0} ->
    # #       [{replace_first_qm(sources, ?.), 0}]

    # #     {sources, n_dist_broken} ->
    # #       [{replace_first_qm(sources, ?.), n_dist_broken}, {replace_first_qm(sources, ?#), n_dist_broken - 1}]
    # #   end)
    # # end)
    stream
    |> Stream.map(fn {built, _} -> built end)
    |> Enum.count(fn built ->
      valid = validate_counts(built, counts)
      matches = match_mask(built, sources)

      # IO.puts("-----------")
      # built |> IO.inspect(label: ~S/--built/)
      # sources |> IO.inspect(label: ~S/sources/)
      # matches |> IO.inspect(label: ~S/matches/)
      # IO.puts("-----------")

      valid and matches
    end)
    |> dbg()
  end

  defp partial_match([h_ok | ok_counts], sources, [h_broken | broken_counts]) do
    with {:ok, sources_rest} <- check_fits(sources, ?., h_ok),
         {:ok, sources_rest} <- check_fits(sources_rest, ?#, h_broken) do
      partial_match(ok_counts, sources_rest, broken_counts)
    else
      :error -> false
    end
  end

  defp partial_match([h_ok], sources, []) do
    with {:ok, sources_rest} <- check_fits(sources, ?., h_ok) do
      true
    else
      :error -> false
    end
  end

  defp check_fits(rest, _c, 0), do: {:ok, rest}
  defp check_fits([c | rest], c, n), do: check_fits(rest, c, n - 1)
  defp check_fits([?? | rest], c, n), do: check_fits(rest, c, n - 1)
  defp check_fits([_ | _rest], _c, n), do: :error

  defp validate_counts(built, expected) do
    actual = rebuild_counts(built, [])
    # expected |> IO.inspect(label: ~S/expected/)
    # actual |> IO.inspect(label: ~S/actual/)
    actual == expected
    # |> IO.inspect(label: ~S/same?/)
  end

  defp rebuild_counts([], [0 | t]) do
    :lists.reverse(t)
  end

  defp rebuild_counts([], t) do
    :lists.reverse(t)
  end

  defp rebuild_counts(chars, acc) do
    chars =
      Enum.drop_while(chars, fn
        ?. -> true
        ?? -> true
        ?# -> false
      end)

    brokens =
      Enum.take_while(chars, fn
        ?. -> false
        ?? -> false
        ?# -> true
      end)

    count = length(brokens)
    rest = Enum.drop(chars, count)

    rebuild_counts(rest, [count | acc])
  end

  defp rebuild_counts([?. | t], _, count, acc) do
    rebuild_counts(t, ?., 0, [count | acc])
  end

  defp replace_first_qm([?? | t], c), do: [c | t]
  defp replace_first_qm([h | t], c), do: [h | replace_first_qm(t, c)]

  defp replace_all_qms([?? | t], c), do: [c | replace_all_qms(t, c)]
  defp replace_all_qms([h | t], c), do: [h | replace_all_qms(t, c)]
  defp replace_all_qms([], _c), do: []

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
    Stream.flat_map(stream, fn group ->
      Enum.map(0..max_group_index, fn i -> List.update_at(group, i, &(&1 + 1)) end)
    end)
  end

  defp distribute_to_enum(stream, max_group_index) do
    Enum.flat_map(stream, fn group ->
      Enum.map(0..max_group_index, fn i -> List.update_at(group, i, &(&1 + 1)) end)
    end)
    |> Enum.uniq()
  end
end
