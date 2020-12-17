defmodule Aoe.Y20.Day17 do
  alias Aoe.Input, warn: false
  import Enum, only: [with_index: 1]

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    file
    |> Input.stream_file_lines(trim: true)
    |> Enum.to_list()
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, :part_one) do
    z = 0

    map =
      for {row, y} <- with_index(input),
          {col, x} <- with_index(String.to_charlist(row)),
          into: %{},
          do: {{x, y, z}, parse_char(col)}

    max_x = Enum.max(map |> Enum.map(fn {{x, _, _}, _} -> x end))
    min_x = Enum.min(map |> Enum.map(fn {{x, _, _}, _} -> x end))
    max_y = Enum.max(map |> Enum.map(fn {{_, y, _}, _} -> y end))
    min_y = Enum.min(map |> Enum.map(fn {{_, y, _}, _} -> y end))

    Map.put(map, :domain, {min_x, max_x, min_y, max_y, 0, 0})
  end

  def parse_input!(input, :part_two) do
    z = 0
    w = 0

    map =
      for {row, y} <- with_index(input),
          {col, x} <- with_index(String.to_charlist(row)),
          into: %{},
          do: {{x, y, z, w}, parse_char(col)}

    max_x = Enum.max(map |> Enum.map(fn {{x, _, _, _}, _} -> x end))
    min_x = Enum.min(map |> Enum.map(fn {{x, _, _, _}, _} -> x end))
    max_y = Enum.max(map |> Enum.map(fn {{_, y, _, _}, _} -> y end))
    min_y = Enum.min(map |> Enum.map(fn {{_, y, _, _}, _} -> y end))

    Map.put(map, :domain, {min_x, max_x, min_y, max_y, 0, 0, 0, 0})
  end

  @active 1
  @inactive 0

  defp parse_char(?#), do: @active
  defp parse_char(?.), do: @inactive

  def part_one(problem) do
    map = apply_rules_p1(problem, 6)

    for {_, v} <- map, v == @active do
      1
    end
    |> Enum.sum()
  end

  def part_two(problem) do
    map = apply_rules_p2(problem, 6)

    for {_, v} <- map, v == @active do
      1
    end
    |> Enum.sum()
  end

  defp apply_rules_p1(map, 0) do
    map
  end

  defp apply_rules_p1(%{domain: domain} = map, turn) do
    {min_x, max_x, min_y, max_y, min_z, max_z} = expand_domain_once(domain)

    changes =
      for x <- min_x..max_x, y <- min_y..max_y, z <- min_z..max_z, reduce: [] do
        changes ->
          coords = {x, y, z}
          anc = active_neighbours_count(map, coords)
          maybe_push_change(coords, map, anc, changes)
      end

    new_domain = expand_domain_from_changes(domain, changes)

    map
    |> Map.put(:domain, new_domain)
    |> Map.merge(Map.new(changes))
    |> apply_rules_p1(turn - 1)
  end

  defp maybe_push_change(coords, map, anc, changes) do
    current = Map.get(map, coords, @inactive)

    case {current, anc} do
      {@active, c} when c in [2, 3] -> changes
      {@active, _} -> [{coords, @inactive} | changes]
      {@inactive, 3} -> [{coords, @active} | changes]
      {@inactive, _} -> changes
    end
  end

  defp apply_rules_p2(map, 0) do
    map
  end

  defp apply_rules_p2(%{domain: domain} = map, turn) do
    {min_x, max_x, min_y, max_y, min_z, max_z, min_w, max_w} = expand_domain_once(domain)

    changes =
      for x <- min_x..max_x,
          y <- min_y..max_y,
          z <- min_z..max_z,
          w <- min_w..max_w,
          reduce: [] do
        changes ->
          coords = {x, y, z, w}
          anc = active_neighbours_count(map, coords)
          maybe_push_change(coords, map, anc, changes)
      end

    new_domain = expand_domain_from_changes(domain, changes)

    map
    |> Map.put(:domain, new_domain)
    |> Map.merge(Map.new(changes))
    |> apply_rules_p2(turn - 1)
  end

  defp expand_domain_once({min_x, max_x, min_y, max_y, min_z, max_z}) do
    {min_x - 1, max_x + 1, min_y - 1, max_y + 1, min_z - 1, max_z + 1}
  end

  defp expand_domain_once({min_x, max_x, min_y, max_y, min_z, max_z, min_w, max_w}) do
    {min_x - 1, max_x + 1, min_y - 1, max_y + 1, min_z - 1, max_z + 1, min_w - 1, max_w + 1}
  end

  defp expand_domain({min_x, max_x, min_y, max_y, min_z, max_z}, {x, y, z}) do
    {min(min_x, x), max(max_x, x), min(min_y, y), max(max_y, y), min(min_z, z), max(max_z, z)}
  end

  defp expand_domain({min_x, max_x, min_y, max_y, min_z, max_z, min_w, max_w}, {x, y, z, w}) do
    {min(min_x, x), max(max_x, x), min(min_y, y), max(max_y, y), min(min_z, z), max(max_z, z),
     min(min_w, w), max(max_w, w)}
  end

  defp expand_domain_from_changes(domain, changes) do
    Enum.reduce(changes, domain, fn
      {coords, @active}, acc -> expand_domain(acc, coords)
      {_coords, @inactive}, acc -> acc
    end)
  end

  defp active_neighbours_count(map, {x, y, z} = coords) do
    for nx <- (x - 1)..(x + 1),
        ny <- (y - 1)..(y + 1),
        nz <- (z - 1)..(z + 1),
        {nx, ny, nz} != coords,
        reduce: 0 do
      acc ->
        Map.get(map, {nx, ny, nz}, 0) + acc
    end
  end

  defp active_neighbours_count(map, {x, y, z, w} = coords) do
    for nx <- (x - 1)..(x + 1),
        ny <- (y - 1)..(y + 1),
        nz <- (z - 1)..(z + 1),
        nw <- (w - 1)..(w + 1),
        {nx, ny, nz, nw} != coords,
        reduce: 0 do
      acc ->
        Map.get(map, {nx, ny, nz, nw}, 0) + acc
    end
  end
end
