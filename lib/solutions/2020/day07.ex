defmodule AdventOfCode.Solutions.Y20.Day07 do
  alias AoC.Input

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Enum.map(&parse_rule/1)
    |> Enum.map(&as_kv/1)
  end

  defp parse_rule(rule) do
    words = String.split(rule, [" ", ".", ","], trim: true)
    {parent_color, ["bags", "contain" | words]} = take_color(words)
    parse_children(words, %{pcol: parent_color, children: %{}})
  end

  defp parse_children(["no" | _], rule) do
    rule
  end

  defp parse_children([amt | words], rule) do
    {amt, ""} = Integer.parse(amt)

    # _bags is "bag" or "bags"
    {color, [_bags | words]} = take_color(words)
    {rule, words} = {put_in(rule.children[color], amt), words}

    parse_children(words, rule)
  end

  defp parse_children([], rule) do
    rule
  end

  def take_color([tone, hue | words]) do
    {color!({tone, hue}), words}
  end

  def color!({a, b}) do
    String.to_atom("#{a}_#{b}")
  end

  defp as_kv(%{pcol: key, children: value}) do
    {key, value}
  end

  def part_one(problem) do
    problem
    |> build_child_to_parent()
    |> find_containers(:shiny_gold)
    |> MapSet.size()
  end

  def part_two(problem) do
    graph = Map.new(problem)
    buy_bags(graph, graph[:shiny_gold], 1, 0)
  end

  def buy_bags(graph, to_buy, mult, acc) do
    Enum.reduce(to_buy, acc, fn {color, amt}, acc ->
      real_amt = amt * mult
      buy_bags(graph, graph[color], real_amt, acc + real_amt)
    end)
  end

  defp build_child_to_parent(kvlist) do
    Enum.reduce(kvlist, %{}, &build_child_to_parent/2)
  end

  defp build_child_to_parent({pcol, children}, reversed) do
    Enum.reduce(children, reversed, fn {child_color, _amt}, graph ->
      Map.update(graph, child_color, [pcol], &[pcol | &1])
    end)
  end

  defp find_containers(child2p, key, acc \\ MapSet.new())

  defp find_containers(child2p, key, acc) do
    parents = Map.get(child2p, key, [])
    acc = MapSet.union(acc, MapSet.new(parents))

    Enum.reduce(parents, acc, fn parent, acc ->
      find_containers(child2p, parent, acc)
    end)
  end
end
