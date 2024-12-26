defmodule AdventOfCode.Solutions.Y23.Day19 do
  alias AoC.Input

  @re_part ~r/{x=([0-9]+),m=([0-9]+),a=([0-9]+),s=([0-9]+)}/
  @re_wf ~r/([a-z]+)\{(.+)\}/

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    [workflows, parts] = String.split(input, "\n\n")

    workflows = workflows |> String.split("\n", trim: true) |> Enum.map(&parse_workflow/1) |> Map.new()

    parts = parts |> String.split("\n", trim: true) |> Enum.map(&parse_part/1)

    {workflows, parts}
  end

  defp parse_workflow(string) do
    [_, name, rules] = Regex.run(@re_wf, string)
    rules = rules |> String.split(",") |> Enum.map(&parse_rule/1)
    {name, rules}
  end

  defp parse_rule(rule) do
    case String.split(rule, ":") do
      [matcher, next] -> {:match, parse_matcher(matcher), parse_next(next)}
      [single] -> {:always, parse_next(single)}
    end
  end

  defp parse_next(next) do
    case next do
      "A" -> :accept
      "R" -> :reject
      next -> {:next, next}
    end
  end

  defp parse_matcher(c) do
    case c do
      "a>" <> v -> {:a, :gt, String.to_integer(v)}
      "a<" <> v -> {:a, :lt, String.to_integer(v)}
      "s>" <> v -> {:s, :gt, String.to_integer(v)}
      "s<" <> v -> {:s, :lt, String.to_integer(v)}
      "m>" <> v -> {:m, :gt, String.to_integer(v)}
      "m<" <> v -> {:m, :lt, String.to_integer(v)}
      "x>" <> v -> {:x, :gt, String.to_integer(v)}
      "x<" <> v -> {:x, :lt, String.to_integer(v)}
    end
  end

  defp parse_part(string) do
    # regex that can extract the key and values from a structure like this : {x=787,m=2655,a=1222,s=2876}
    [_, x, m, a, s] = Regex.run(@re_part, string)
    %{x: String.to_integer(x), m: String.to_integer(m), a: String.to_integer(a), s: String.to_integer(s)}
  end

  def part_one({workflows, parts}) do
    wf_in = Map.fetch!(workflows, "in")

    parts
    |> Enum.filter(fn part -> accept_part(part, wf_in, workflows) end)
    |> Enum.reduce(0, &sum_parts/2)
  end

  defp accept_part(part, [rule | rules], wfs) do
    case rule do
      {:always, {:next, wfkey}} ->
        next_workflow(part, wfkey, wfs)

      {:always, :reject} ->
        false

      {:always, :accept} ->
        true

      {:match, matcher, then} ->
        if matches(matcher, part) do
          case then do
            :reject -> false
            :accept -> true
            {:next, wfkey} -> next_workflow(part, wfkey, wfs)
          end
        else
          accept_part(part, rules, wfs)
        end
    end
  end

  defp next_workflow(part, wfkey, wfs) do
    accept_part(part, Map.fetch!(wfs, wfkey), wfs)
  end

  defp matches({:a, :lt, n}, %{a: a}), do: a < n
  defp matches({:a, :gt, n}, %{a: a}), do: a > n
  defp matches({:s, :lt, n}, %{s: s}), do: s < n
  defp matches({:s, :gt, n}, %{s: s}), do: s > n
  defp matches({:m, :lt, n}, %{m: m}), do: m < n
  defp matches({:m, :gt, n}, %{m: m}), do: m > n
  defp matches({:x, :lt, n}, %{x: x}), do: x < n
  defp matches({:x, :gt, n}, %{x: x}), do: x > n

  defp sum_parts(%{x: x, m: m, a: a, s: s}, acc) do
    rating = x + m + a + s
    rating + acc
  end

  def part_two({wfs, _}) do
    init = %{a: 1..4000, m: 1..4000, s: 1..4000, x: 1..4000, wk: "in"}
    states = [init]
    accepted_states = reduce(states, wfs, [])

    Enum.map(accepted_states, &count_combinations/1)
    |> Enum.sum()
  end

  defp reduce([h | t], wfs, accepted) do
    {next_states, accepted} = run_state(h, wfs, accepted)
    new_states = next_states ++ t
    reduce(new_states, wfs, accepted)
  end

  defp reduce([], _wfs, accepted) do
    accepted
  end

  defp run_state(:rejected, _wfs, accepted) do
    {[], accepted}
  end

  defp run_state(%{wk: :accepted} = state, _wfs, accepted) do
    {[], [state | accepted]}
  end

  defp run_state(%{wk: wk} = original_state, wfs, accepted) do
    wf = Map.fetch!(wfs, wk)

    Enum.reduce(wf, {original_state, []}, fn rule, {state, next_states} ->
      case split_state(state, rule) do
        {passes, nil} -> {nil, [passes | next_states]}
        {passes, remains} -> {remains, [passes | next_states]}
      end
    end)
    |> case do
      {nil, next_states} -> {next_states, accepted}
    end
  end

  defp split_state(state, {:match, matcher, then}) do
    {passes, remains} = do_split(state, matcher)
    {apply_then(passes, then), remains}
  end

  defp split_state(state, {:always, then}) do
    {apply_then(state, then), nil}
  end

  Enum.each([:s, :m, :x, :a], fn k ->
    defp do_split(state, {unquote(k), :lt, n}) do
      a..b//1 = Map.fetch!(state, unquote(k))

      # this is always true
      # true = a < n && b > n do

      passes = Map.put(state, unquote(k), a..(n - 1))
      remains = Map.put(state, unquote(k), n..b)
      {passes, remains}
    end

    defp do_split(state, {unquote(k), :gt, n}) do
      a..b//1 = Map.fetch!(state, unquote(k))

      # this is always true
      # true = a < n && b > n do

      passes = Map.put(state, unquote(k), (n + 1)..b)
      remains = Map.put(state, unquote(k), a..n)
      {passes, remains}
    end
  end)

  defp apply_then(state, {:next, wk}) do
    %{state | wk: wk}
  end

  defp apply_then(_state, :reject) do
    :rejected
  end

  defp apply_then(state, :accept) do
    %{state | wk: :accepted}
  end

  defp count_combinations(%{s: sa..sz//1, m: ma..mz//1, a: aa..az//1, x: xa..xz//1}) do
    Range.size(sa..sz) * Range.size(ma..mz) * Range.size(aa..az) * Range.size(xa..xz)
  end
end
