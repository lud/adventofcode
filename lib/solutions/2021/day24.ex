defmodule AdventOfCode.Y21.Day24 do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y21.Day24.Program

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(_file, _part) do
    # Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
    "nope"
  end

  def parse_input(_input, _part) do
    nil
  end

  # @td List.duplicate(nil, 14) |> List.to_tuple()
  @td 0

  def part_one(_problem) do
    {_dmin, dmax} = part_all(:higher)
    dmax
  end

  def part_two(_problem) do
    {dmin, _} = part_all(:lower)
    dmin
  end

  def part_all(bester) do
    _z = 0
    _index = 0
    seen = %{}
    states = [{_z = 0, _digits = @td}]
    states = run_index(0, states, seen, bester)
    states = run_index(1, states, seen, bester)
    states = run_index(2, states, seen, bester)
    states = run_index(3, states, seen, bester)
    states = run_index(4, states, seen, bester)
    states = run_index(5, states, seen, bester)
    states = run_index(6, states, seen, bester)
    states = run_index(7, states, seen, bester)
    states = run_index(8, states, seen, bester)
    states = run_index(9, states, seen, bester)
    states = run_index(10, states, seen, bester)
    states = run_index(11, states, seen, bester)
    states = run_index(12, states, seen, bester)
    states = run_index(13, states, seen, bester)

    min_max(states)
  end

  defp min_max([{_z = 0, digits} | rest]) do
    min_max(rest, digits, digits)
  end

  defp min_max([_ | rest]) do
    min_max(rest)
  end

  defp min_max([{0, candidate} | rest], dmin, dmax) do
    min_max(rest, min(dmin, candidate), max(dmax, candidate))
  end

  defp min_max([_ | rest], dmin, dmax) do
    min_max(rest, dmin, dmax)
  end

  defp min_max([], dmin, dmax) do
    {dmin, dmax}
  end

  defp run_index(index, states, _seen, bester) do
    seens =
      Enum.map(1..9, fn w ->
        Task.async(fn ->
          IO.puts("w = #{w}")

          new_seen =
            Enum.reduce(states, %{}, fn {z, digits}, seen ->
              z = Program.run(index, w, z)
              digits = digits * 10 + w

              case Map.get(seen, z) do
                nil -> Map.put(seen, z, digits)
                other_digits when other_digits >= digits -> seen
                _ -> Map.put(seen, z, digits)
              end
            end)

          {w, new_seen}
        end)
      end)

    seen = Enum.reduce(seens, %{}, &await_merge_best(&1, &2, bester))

    states = Map.to_list(seen)
    IO.puts("after: #{length(states)}")
    states
  end

  def await_merge_best(task, map1, :higher) do
    {w, map2} = Task.await(task, :infinity)
    map = Map.merge(map1, map2, fn _, v1, v2 -> max(v1, v2) end)
    IO.puts("w = #{w} OK")
    map
  end

  def await_merge_best(task, map1, :lower) do
    {w, map2} = Task.await(task, :infinity)
    map = Map.merge(map1, map2, fn _, v1, v2 -> min(v1, v2) end)
    IO.puts("w = #{w} OK")
    map
  end
end
