defmodule AdventOfCode.Solutions.Y25.Day11 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Map.new(&parse_line/1)
  end

  defp parse_line(line) do
    <<inp::binary-size(3), ?:, rest::binary>> = line

    out =
      Enum.to_list(
        Stream.unfold(rest, fn
          <<>> -> nil
          <<?\s, out::binary-size(3), next::binary>> -> {out, next}
        end)
      )

    {inp, out}
  end

  def part_one(full_io) do
    # out_in =
    #   Enum.reduce(full_io, %{}, fn {inp, outs}, acc ->
    #     Enum.reduce(outs, acc, fn out, acc ->
    #       Map.update(acc, out, [inp], &[inp | &1])
    #     end)
    #   end)

    # lead_to_out = exit_paths(out_in, ["out"], %{})
    # paths = build_paths(full_io,"you",%{})
    counts = count_paths(full_io, "you", %{"out" => 1})
    Map.fetch!(counts, "you")
  end

  defp count_paths(full_io, "out", acc) do
    raise "not called"
  end

  defp count_paths(full_io, todo, acc) do
    todo |> dbg()
    exits = Map.fetch!(full_io, todo)
    exits |> dbg()

    acc =
      Enum.reduce(exits, acc, fn exit_, acc ->
        acc =
          if Map.has_key?(acc, exit_) do
            acc
          else
            count_paths(full_io, exit_, acc)
          end
      end)

    value = Enum.sum_by(exits, &Map.fetch!(acc, &1))

    Map.put(acc, todo, value)
  end

  # defp build_paths(full_io,current, acc ) do
  #   outs = Map.fetch!(full_io,current)
  #   Map.put
  # end

  def part_two(full_io) do
    paths = walk(full_io, [["svr"]], 0)
  end

  defp walk(_, [], count) do
    count
  end

  defp walk(full_io, states, count) do
    {states, count} =
      Enum.flat_map_reduce(states, count, fn [h | _] = path, count ->
        Enum.flat_map_reduce(Map.fetch!(full_io, h), count, fn
          "out", count ->
            if "fft" in path and "dac" in path do
              {[], count + 1}
            else
              {[], count}
            end

          exit_, count ->
            {[[exit_ | path]], count}
        end)
      end)

    length(states) |> dbg(limit: :infinity)

    walk(full_io, states, count)
  end
end
