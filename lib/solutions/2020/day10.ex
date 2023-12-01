defmodule AdventOfCode.Y20.Day10 do
  alias AoC.Input, warn: false
  require ExUnit.Assertions

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    adapters =
      input
      |> Input.stream_to_integers()
      |> Enum.to_list()

    device = Enum.max(adapters) + 3
    {adapters, device}
  end

  def part_one({adapters, device}) do
    problem = Enum.sort([device | adapters])
    # {:ok, chain} = find_chain(0, problem)

    # chain |> IO.inspect(label: "chain")
    {a, b} = calc_differences([0 | problem], {0, 0})
    a * b
  end

  defp calc_differences([_], acc) do
    acc
  end

  defp calc_differences([a, b | rest], {ones, threes}) when b - a == 1 do
    calc_differences([b | rest], {ones + 1, threes})
  end

  defp calc_differences([a, b | rest], {ones, threes}) when b - a == 3 do
    calc_differences([b | rest], {ones, threes + 1})
  end

  # defp find_chain(input, [], acc) do
  #   {:ok, :lists.reverse(acc)}
  # end

  # def adapter_match(adapter, input) when adapter >= input and adapter - input < 4 do
  #   true
  # end

  # def adapter_match(adapter, input) do
  #   false
  # end

  # defp find_chain(input, []) do
  #   {:ok, []}
  # end

  # defp find_chain(input, adapters) do
  #   IO.puts(String.duplicate("·", length(adapters)))
  #   candidates = Enum.filter(adapters, &adapter_match(&1, input))

  #   result =
  #     Enum.find_value(candidates, :backtrack, fn cand ->
  #       rest = adapters -- [cand]

  #       case find_chain(cand, rest) do
  #         :backtrack -> false
  #         {:ok, sub} -> {:ok, [cand | sub]}
  #       end
  #     end)
  # end

  def part_two({adapters, device}) do
    problem = Enum.sort([device | adapters])
    reachmap = build_reachmap([0 | problem], %{})
    countmap = %{device => 1}

    [0 | adapters]
    |> Enum.sort()
    |> :lists.reverse()
    |> Enum.reduce(countmap, fn adapter, countmap ->
      nexts = reachmap[adapter]
      count = Enum.reduce(nexts, 0, &(&2 + countmap[&1]))
      Map.put(countmap, adapter, count)
    end)
    |> Map.get(0)
  end

  defp build_reachmap([h | t], map) do
    build_reachmap(t, Map.put(map, h, find_reachables(h, t, [])))
  end

  defp build_reachmap([], map) do
    map
  end

  defp find_reachables(input, [h | t], acc) when h - input < 4 do
    find_reachables(input, t, [h | acc])
  end

  defp find_reachables(_, _, acc) do
    acc
  end
end
