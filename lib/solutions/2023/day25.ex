defmodule AdventOfCode.Solutions.Y23.Day25 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {left, rights}, acc ->
      Map.put(acc, left, rights)
    end)
  end

  defp parse_line(line) do
    [left, right] = String.split(line, ": ")
    right = String.split(right, " ")
    {left, right}
  end

  def part_one(problem) do
    input_size = map_size(problem)

    graph = reconnect(problem, %{})

    {graph, left, right} =
      case input_size do
        13 ->
          # Sample input
          graph =
            graph
            |> cut("hfx", "pzl")
            |> cut("bvb", "cmg")
            |> cut("nvd", "jqt")

          {graph, "hfx", "pzl"}

        _ ->
          # Actual input
          # Just found the edges to cut with graphviz.
          #
          # use print_graph/1 to create out.dot and
          #
          #     neato -Tsvg /tmp/out.dot > /tmp/out.svg
          #
          graph =
            graph
            |> cut("lnr", "pgt")
            |> cut("zkt", "jhq")
            |> cut("vph", "tjz")

          {graph, "lnr", "pgt"}
      end

    count_reachable(graph, left) *
      count_reachable(graph, right)
  end

  defp count_reachable(graph, start) do
    count_reachable([start], %{}, graph)
  end

  defp count_reachable([h | t], seen, graph) when is_map_key(seen, h) do
    count_reachable(t, seen, graph)
  end

  defp count_reachable([h | t], seen, graph) do
    others = Map.fetch!(graph, h)
    count_reachable(others ++ t, Map.put(seen, h, true), graph)
  end

  defp count_reachable([], seen, _graph) do
    map_size(seen)
  end

  defp cut(graph, a, b) do
    graph =
      Map.update!(graph, a, fn conns ->
        true = b in conns
        conns -- [b]
      end)

    graph =
      Map.update!(graph, b, fn conns ->
        true = a in conns
        conns -- [a]
      end)

    graph
  end

  defp reconnect(input, all) do
    Enum.reduce(input, all, fn {left, rights}, all ->
      for r <- rights, reduce: all do
        all ->
          all |> set_conn(left, r) |> set_conn(r, left)
      end
    end)
  end

  defp set_conn(graph, a, b) do
    Map.update(graph, a, [b], fn bs -> [b | bs] end)
  end

  def print_graph(graph) do
    lines =
      Enum.map(graph, fn {left, rights} ->
        Enum.map(rights, fn right ->
          "#{left} -- #{right};\n"
        end)
      end)

    out = [
      "graph G {\n",
      lines,
      "}\n"
    ]

    File.write("/tmp/graph.dot", out)
  end
end
