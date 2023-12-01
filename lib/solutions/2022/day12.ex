defmodule Aoe.Y22.Day12 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file(file, _part) do
    Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input(input, _part) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.flat_map(&parse_row/1)
    |> Map.new()
  end

  defp parse_row({cols, y}) do
    Enum.map(cols, &parse_col(&1, y))
  end

  defp parse_col({char, x}, y) do
    cost =
      case char do
        "S" -> 0
        _ -> nil
      end

    {height, kind} =
      case char do
        "S" -> {"a", :start}
        "E" -> {"z", :target}
        c -> {c, :cell}
      end

    {{x, y}, %{h: height, parent: nil, cost: cost, kind: kind}}
  end

  def part_one(map) do
    map |> dijkstra(&can_climb?/2) |> find_path()
  end

  defp find_path(map) do
    {start, _} = Enum.find(map, fn {_, %{kind: k}} -> k == :target end)

    Stream.unfold(start, fn prev ->
      case Map.fetch!(map, prev) do
        %{kind: :cell} = c -> {c, c.parent}
        %{kind: :target} = c -> {c, c.parent}
        %{kind: :start} = _ -> nil
      end
    end)
    |> Enum.count()
  end

  def part_two(map) do
    {xy_start, %{kind: :start}} = Enum.find(map, fn {_, %{kind: k}} -> k == :start end)
    map = Map.update!(map, xy_start, &(&1 |> Map.merge(%{kind: :cell, cost: nil})))

    {xy_target, %{kind: :target}} = Enum.find(map, fn {_, %{kind: k}} -> k == :target end)
    map = Map.update!(map, xy_target, &(&1 |> Map.merge(%{kind: :start, cost: 0})))

    map = dijkstra(map, &can_be_climbed/2)

    map
    |> Map.values()
    |> Enum.filter(fn %{h: h} -> h == "a" end)
    |> Enum.min_by(fn %{cost: c} -> c end)
    |> Map.get(:cost)
  end

  defp dijkstra(map, access_check) do
    {{sx, sy}, %{kind: :start}} = Enum.find(map, fn {_, %{kind: k}} -> k == :start end)
    dijkstra(map, [{sx, sy}], [], access_check)
  end

  defp dijkstra(map, [cur | open], new_open, access_check) do
    cell = Map.fetch!(map, cur)
    cost = cell.cost
    true = nil != cost
    neighs_xy = cardinal(cur)

    {new_open, map} =
      neighs_xy
      |> Enum.filter(&Map.has_key?(map, &1))
      |> Enum.reduce({new_open, map}, fn xy, {new_open, map} ->
        %{cost: neigh_cost} = neigh = Map.fetch!(map, xy)

        if access_check.(cell, neigh) do
          {add?, new_neigh} =
            case neigh_cost do
              nil -> {true, Map.merge(neigh, %{cost: cost + 1, parent: cur})}
              n when n > cost + 1 -> {true, Map.merge(neigh, %{cost: cost + 1, parent: cur})}
              _ -> {false, nil}
            end

          if add? do
            {[xy | new_open], Map.put(map, xy, new_neigh)}
          else
            {new_open, map}
          end
        else
          {new_open, map}
        end
      end)

    dijkstra(map, open ++ :lists.reverse(new_open), [], access_check)
  end

  defp dijkstra(map, [], [], _) do
    map
  end

  defp cardinal({x, y}) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
  end

  defp can_climb?(%{h: <<h_from>>}, %{h: <<h_to>>}) do
    h_to <= h_from + 1
  end

  defp can_be_climbed(a, b), do: can_climb?(b, a)
end
