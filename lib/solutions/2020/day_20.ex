defmodule Aoe.Y20.Day20 do
  alias Aoe.Input, warn: false
  import :lists, only: [reverse: 1]

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.read!(file)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input
    |> String.split(~r/\n{2,}/, trim: true)
    |> Enum.map(&parse_tile/1)
    |> Map.new()
  end

  defdelegate stc(str), to: String, as: :to_charlist

  defp parse_tile("Tile " <> rest) do
    [header | rows] = String.split(rest, "\n", trim: true)
    {id, ":"} = Integer.parse(header)
    {id, rows |> Enum.map(&stc/1)}
  end

  def part_one(map) do
    map =
      map
      |> Enum.map(&expand_tile/1)
      |> Map.new()

    all_signatures =
      map
      |> Enum.reduce(%{}, &register_signatures/2)

    # to solve part 1 we get all sides that have only two neighbours
    # the we multiply
    all_signatures
    |> get_corners
    |> Enum.reduce(1, fn corner_id, acc -> corner_id * acc end)
  end

  defp get_corners(all_signatures) do
    all_signatures
    |> Enum.filter(fn {_sign, tiles_sides} ->
      length(tiles_sides) == 1
    end)
    # then we discard the signature and keep the {id, side} tuples
    |> Enum.map(&elem(&1, 1))
    |> :lists.flatten()
    # we count the frequencies by id. A corner has only two sides with
    # neighbours, so it should be found twice in this list of sides without
    # connexion. But as we have registered each side normal and reversed, we
    # look for ids that appear four times.
    # 
    # first we count the frequencies by id
    |> Enum.frequencies_by(&elem(&1, 0))
    # and take thoses that appear four times
    |> Enum.filter(&(elem(&1, 1) == 4))
    |> Enum.map(&elem(&1, 0))
  end

  defp expand_tile({id, rows}, signatures? \\ true, coords \\ nil) do
    top_row = rows |> hd
    bottom_row = rows |> List.last()
    left_col = rows |> Enum.map(&hd/1)
    right_col = rows |> Enum.map(&List.last/1)

    {id,
     %{
       coords: coords,
       id: id,
       rows: rows,
       top: top_row,
       bottom: bottom_row,
       left: left_col,
       right: right_col,
       signatures:
         if signatures? do
           [
             top: top_row,
             bottom: bottom_row,
             left: left_col,
             right: right_col,
             top_rev: reverse(top_row),
             bottom_rev: reverse(bottom_row),
             left_rev: reverse(left_col),
             right_rev: reverse(right_col)
           ]
         else
           nil
         end
       # signatures: [
       #   signature(top_row),
       #   signature(bottom_row),
       #   signature(left_col),
       #   signature(right_col)
       # ]
     }}
  end

  defp register_signatures({id, %{signatures: signatures}}, acc) do
    signatures
    |> Enum.reduce(acc, fn {side, signature}, acc ->
      Map.update(acc, signature, [{id, side}], &[{id, side} | &1])
    end)
  end

  def part_two(map) do
    map =
      map
      |> Enum.map(&expand_tile/1)
      |> Map.new()

    registry =
      map
      |> Enum.reduce(%{}, &register_signatures/2)

    # get a random corder
    [corner_id | _] = get_corners(registry)

    # to assemble the map we initialize it with a corner tile
    to_check = as_checkables(corner_id)
    pool = Map.delete(map, corner_id)

    correct_map = %{corner_id => Map.put(Map.get(map, corner_id), :coords, {0, 0})}

    # build a registry to find a tile from a side
    registry = unregister(registry, Map.get(map, corner_id))

    final_grid = assemble_map(to_check, correct_map, pool, registry)

    solution_grid = find_monsters(final_grid)

    solution_grid
    |> :lists.flatten()
    |> Enum.reduce(0, fn
      ?#, acc -> acc + 1
      _, acc -> acc
    end)
  end

  defp find_monsters(final_grid) do
    rotations = [:normal, {:rotate, 90}, {:rotate, -90}, {:rotate, 180}]
    flips = [:normal, :flip_horiz, :flip_vert, :flip_both]

    {transform, monsters_middle} =
      for rotation <- rotations, flip <- flips do
        grid = final_grid |> apply_transform(rotation) |> apply_transform(flip)
        monsters = match_monsters(grid)
        {{rotation, flip}, monsters}
      end
      |> Enum.filter(fn
        {_, []} -> false
        {_, _} -> true
      end)
      |> hd

    {t1, t2} = transform

    solution_grid =
      final_grid
      |> apply_transform(t1)
      |> apply_transform(t2)

    Enum.reduce(monsters_middle, solution_grid, fn {x, y}, grid ->
      replace_monster(grid, x, y - 1)
    end)

    # |> print_final_grid
  end

  # 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,14,15,16,17,18,19
  # __,__,__,__,__,__,__,__,__,__,__,__,__,__,__,__,__,__,?#,__,
  # ?#,__,__,__,__,?#,?#,__,__,__,__,?#,?#,__,__,__,__,?#,?#,?#,
  # __,?#,__,__,?#,__,__,?#,__,__,?#,__,__,?#,__,__,?#,__,__,__,
  @monster_parts Enum.map([18], &{&1, 0}) ++
                   Enum.map([0, 5, 6, 11, 12, 17, 18, 19], &{&1, 1}) ++
                   Enum.map([1, 4, 7, 10, 13, 16], &{&1, 2})

  defp replace_monster(grid, x, y) do
    Enum.reduce(@monster_parts, grid, fn {px, py}, grid ->
      replace_char(grid, px + x, py + y, [
        IO.ANSI.light_green(),
        IO.ANSI.bright(),
        ?O,
        IO.ANSI.reset()
      ])
    end)
  end

  defp replace_char(grid, x, y, char) do
    row = Enum.at(grid, y)
    new_row = List.replace_at(row, x, char)
    List.replace_at(grid, y, new_row)
  end

  defp match_monsters(grid) do
    # match the second line of the monster as it is the most specific.
    # As it is the second line, start search at rowindex 1 and end at max-y - 1
    # 
    # We build a list of matches as {x_index, y_index} for the grid
    max_row = length(grid) - 2

    middle_indexes =
      grid
      |> Enum.slice(1..max_row)
      |> Enum.map(&match_middle(&1, 0, []))
      |> Enum.with_index(1)
      |> Enum.filter(fn {x_indexes, _y} -> length(x_indexes) > 0 end)

    # we will flatten our pairs of coordinates : [{[x1, x2], y}] -> [{x1, y}, {x2, y}]
    middle_indexes = for {xs, y} <- middle_indexes, x <- xs, do: {x, y}

    # case middle_indexes do
    #   [] -> nil
    #   mis -> IO.inspect(mis, label: "middle_indexes")
    # end

    # now we need to validate our sea monsters. for each row/col index where we
    # found a middle-line sea monster, we must match for the other monster rows

    middle_indexes
    |> Enum.filter(fn {x, y} ->
      has_monster_row_1(grid, x, y - 1) and has_monster_row_3(grid, x, y + 1)
    end)
  end

  defp has_monster_row_1(grid, x, y) do
    chars = grid |> Enum.at(y) |> Enum.drop(x)

    has? =
      case(chars) do
        [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, ?# | _] -> true
        _ -> false
      end

    has?
  end

  defp has_monster_row_3(grid, x, y) do
    chars = grid |> Enum.at(y) |> Enum.drop(x)

    has? =
      case chars do
        [_, ?#, _, _, ?#, _, _, ?#, _, _, ?#, _, _, ?#, _, _, ?# | _] -> true
        _ -> false
      end

    has?
  end

  defp match_middle(
         [?#, _, _, _, _, ?#, ?#, _, _, _, _, ?#, ?#, _, _, _, _, ?#, ?#, ?# | _] = list,
         index,
         acc
       ) do
    [_skip | list] = list
    match_middle(list, index + 1, [index | acc])
  end

  defp match_middle([_skip | list], index, acc) do
    # index |> IO.inspect(label: "noindex")
    match_middle(list, index + 1, acc)
  end

  defp match_middle([], _index, acc) do
    acc
  end

  defp as_checkables(id) do
    [{id, :left}, {id, :right}, {id, :top}, {id, :bottom}]
  end

  defp assemble_map([{id, side} | to_check], correct_map, pool, registry) do
    signature = correct_map |> Map.fetch!(id) |> Map.fetch!(side)
    coords = correct_map[id].coords

    case Map.get(registry, signature) do
      nil ->
        assemble_map(to_check, correct_map, pool, registry)

      [{neighbour_id, neighb_side}] ->
        {%{^neighbour_id => neigh}, pool} = Map.split(pool, [neighbour_id])
        registry = unregister(registry, neigh)
        neigh_to_check = as_checkables(neighbour_id)
        transform = find_transform(side, neighb_side)
        neigh_rows = apply_transform(neigh.rows, transform)
        neigh_coords = coords_from(coords, side)
        {^neighbour_id, neigh} = expand_tile({neighbour_id, neigh_rows}, false, neigh_coords)
        correct_map = Map.put(correct_map, neighbour_id, neigh)
        assemble_map(neigh_to_check ++ to_check, correct_map, pool, registry)
    end
  end

  defp assemble_map([], correct_map, pool, _registry) when map_size(pool) == 0 do
    correct_map =
      correct_map
      |> Enum.map(fn {_id, tile} -> {tile.coords, tile} end)
      |> Enum.reduce(%{}, fn {coords, tile}, map ->
        if Map.has_key?(map, coords) do
          raise "coords #{inspect(coords)} already defined"
        end

        Map.put(map, coords, tile)
      end)

    all_coords = Map.keys(correct_map)
    {min_x, _} = Enum.min_by(all_coords, &elem(&1, 0))
    {max_x, _} = Enum.max_by(all_coords, &elem(&1, 0))
    {_, min_y} = Enum.min_by(all_coords, &elem(&1, 1))
    {_, max_y} = Enum.max_by(all_coords, &elem(&1, 1))
    domain = {min_x, max_x, min_y, max_y}
    map = Map.put(correct_map, :domain, domain)

    map =
      map
      |> Enum.map(&remove_borders/1)
      |> Enum.into(%{})

    final_grid = assemble_grid(map)
    final_grid
  end

  def print_final_grid(grid) do
    IO.puts("")

    for row <- grid,
        do:
          IO.puts(
            Enum.map(row, fn
              ?. -> [IO.ANSI.blue(), ?~, IO.ANSI.reset()]
              char -> char
            end)
          )

    grid
  end

  defp remove_borders({coords, %{rows: rows} = tile}) do
    rows = remove_ends(rows)
    rows = Enum.map(rows, &remove_ends/1)
    {coords, Map.put(tile, :rows, rows)}
  end

  defp remove_borders({:domain, _} = domain) do
    domain
  end

  defp remove_ends(list) do
    [_ | tail] = list
    tail |> reverse() |> tl() |> reverse()
  end

  defp assemble_grid(%{domain: {min_x, max_x, min_y, max_y}} = map) do
    for y <- min_y..max_y, i <- 0..7 do
      for x <- min_x..max_x do
        tile = Map.get(map, {x, y})
        Enum.at(tile.rows, i)
      end
      |> :lists.flatten()
    end
  end

  # tells the transform to apply to a nighbour tile for its side (2nd arg) to
  # match the current tile (1st arg).
  defp find_transform(:bottom, :bottom), do: :flip_vert
  defp find_transform(:bottom, :bottom_rev), do: :flip_both
  defp find_transform(:bottom, :left), do: [{:rotate, 90}, :flip_horiz]
  defp find_transform(:bottom, :left_rev), do: {:rotate, 90}
  defp find_transform(:bottom, :right), do: {:rotate, -90}
  defp find_transform(:left, :bottom), do: [{:rotate, -90}, :flip_vert]
  defp find_transform(:left, :bottom_rev), do: {:rotate, -90}
  defp find_transform(:left, :left), do: :flip_horiz
  defp find_transform(:left, :left_rev), do: {:rotate, 180}
  defp find_transform(:left, :right), do: :normal
  defp find_transform(:left, :right_rev), do: :flip_vert
  defp find_transform(:left, :top), do: {:rotate, 90}
  defp find_transform(:left, :top_rev), do: [{:rotate, 90}, :flip_vert]
  defp find_transform(:right, :bottom), do: {:rotate, 90}
  defp find_transform(:right, :bottom_rev), do: [{:rotate, 90}, :flip_vert]
  defp find_transform(:right, :left), do: :normal
  defp find_transform(:right, :left_rev), do: :flip_vert
  defp find_transform(:right, :right), do: :flip_horiz
  defp find_transform(:right, :right_rev), do: {:rotate, 180}
  defp find_transform(:right, :top), do: [:flip_horiz, {:rotate, -90}]
  defp find_transform(:right, :top_rev), do: {:rotate, -90}
  defp find_transform(:top, :bottom), do: :normal
  defp find_transform(:top, :bottom_rev), do: :flip_horiz
  defp find_transform(:top, :left), do: {:rotate, -90}
  defp find_transform(:top, :top_rev), do: {:rotate, 180}

  def apply_transform(rows, :normal), do: rows

  def apply_transform(rows, {:rotate, 180}) do
    rows
    |> reverse
    |> Enum.map(&reverse/1)
  end

  def apply_transform(rows, {:rotate, -90}) do
    rotate_left(rows, [])
  end

  def apply_transform(rows, {:rotate, 90}) do
    rotate_rigth(rows, [])
  end

  def apply_transform(rows, :flip_horiz) do
    Enum.map(rows, &reverse/1)
  end

  def apply_transform(rows, :flip_vert) do
    reverse(rows)
  end

  def apply_transform(rows, :flip_both) do
    apply_transform(rows, [:flip_horiz, :flip_vert])
  end

  def apply_transform(rows, [t | transforms]) do
    rows |> apply_transform(t) |> apply_transform(transforms)
  end

  def apply_transform(rows, []) do
    rows
  end

  defp rotate_left([[] | _], acc) do
    acc
  end

  defp rotate_left(lists, acc) do
    heads = Enum.map(lists, &hd/1)
    tails = Enum.map(lists, &tl/1)
    rotate_left(tails, [heads | acc])
  end

  defp rotate_rigth([[] | _], acc) do
    acc |> :lists.reverse()
  end

  defp rotate_rigth(lists, acc) do
    heads = Enum.map(lists, &hd/1) |> :lists.reverse()

    tails = Enum.map(lists, &tl/1)
    rotate_rigth(tails, [heads | acc])
  end

  defp coords_from({x, y}, :left), do: {x - 1, y}
  defp coords_from({x, y}, :right), do: {x + 1, y}
  defp coords_from({x, y}, :top), do: {x, y - 1}
  defp coords_from({x, y}, :bottom), do: {x, y + 1}

  defp unregister(registry, %{id: id, signatures: signatures}) do
    signatures
    |> Enum.reduce(registry, fn {side, signature}, registry ->
      case Map.get(registry, signature) do
        [] -> exit({:empty, side, id})
        [{_id, _side}] -> Map.delete(registry, signature)
        list -> Map.put(registry, signature, List.keydelete(list, id, 0))
      end
    end)
  end
end
