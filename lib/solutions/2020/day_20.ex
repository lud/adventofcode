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

  def part_one(map, return_data? \\ false) do
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

  @snap_keys ~w(top top_rev bottom bottom_rev left left_rev right right_rev)a

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

    all_signatures =
      map
      |> Enum.reduce(%{}, &register_signatures/2)

    # get a random corder
    [corner_id | _] = get_corners(all_signatures)
    corner_id

    # build a registry to find a tile from a corner
    registry =
      all_signatures
      |> Enum.filter(fn {signature, sides} -> length(sides) > 1 end)
      |> Map.new()

    # to assemble the map we initialize it with a corner
    to_check = as_checkables(corner_id)
    pool = Map.delete(map, corner_id)

    correct_map = %{corner_id => Map.put(Map.get(map, corner_id), :coords, {0, 0})}

    registry = unregister(all_signatures, Map.get(map, corner_id))

    assemble_map(to_check, correct_map, pool, registry)
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
        IO.puts("Added neighbour #{neighbour_id}")
        correct_map = Map.put(correct_map, neighbour_id, neigh)
        assemble_map(neigh_to_check ++ to_check, correct_map, pool, registry)
    end
  end

  defp assemble_map([], correct_map, pool, registry) when map_size(pool) == 0 do
    correct_map =
      correct_map
      |> Enum.map(fn {id, tile} -> {tile.coords, tile} end)
      |> Map.new()

    all_coords = Map.keys(correct_map)
    {min_x, _} = Enum.min_by(all_coords, &elem(&1, 0))
    {max_x, _} = Enum.max_by(all_coords, &elem(&1, 0))
    {_, min_y} = Enum.min_by(all_coords, &elem(&1, 1))
    {_, max_y} = Enum.max_by(all_coords, &elem(&1, 1))
    domain = {min_x, max_x, min_y, max_y}
    map = Map.put(correct_map, :domain, domain)

    print_map_ids(map)
    print_map_overlaps(map, 0..9)

    map =
      map
      |> Enum.map(&remove_borders/1)
      |> Enum.into(%{})

    final_grid = assemble_grid(map)
  end

  defp remove_borders({coords, %{rows: rows} = tile}) do
    rows = remove_ends(rows)
    rows = Enum.map(rows, &remove_ends/1)
    {coords, Map.put(tile, :rows, rows)}
  end

  defp remove_ends(list) do
    [_ | tail] = list
    tail |> reverse() |> tl() |> reverse()
  end

  defp remove_borders({:domain, _} = domain) do
    domain
  end

  defp print_map_ids(%{domain: {min_x, max_x, min_y, max_y}} = map) do
    # map = Enum.map(map, fn {coords, %{rows: rows} = tile} ->
    #   rows = Enum.map(rows, &[?\s|&1]) ++ ['          ']
    #   {coord, Map.put(tile, :rows, rows)}
    # end)
    # |> Enum.into(%{})
    for y <- min_y..max_y do
      for x <- min_x..max_x do
        tile = Map.get(map, {x, y})
        IO.write("#{tile.id} ")
      end

      IO.puts("")
    end
  end

  defp print_map_overlaps(%{domain: {min_x, max_x, min_y, max_y}} = map, dimension) do
    # map = Enum.map(map, fn {coords, %{rows: rows} = tile} ->
    #   rows = Enum.map(rows, &[?\s|&1]) ++ ['          ']
    #   {coord, Map.put(tile, :rows, rows)}
    # end)
    # |> Enum.into(%{})
    for y <- min_y..max_y do
      for i <- dimension do
        for x <- min_x..max_x do
          tile = Map.get(map, {x, y})
          IO.write(Enum.at(tile.rows, i))
          IO.write("  ")
        end

        IO.puts("")
      end

      IO.puts("")
    end
  end

  defp assemble_grid(%{domain: {min_x, max_x, min_y, max_y}} = map) do
    for y <- min_y..max_y, i <- 0..7 do
      big_row =
        for x <- min_x..max_x do
          tile = Map.get(map, {x, y})
          row = Enum.at(tile.rows, i)
        end
        |> :lists.flatten()
    end
  end

  defp find_transform(:right, :right_rev), do: {:rotate, 180}
  defp find_transform(:top, :top_rev), do: {:rotate, 180}
  defp find_transform(:left, :left_rev), do: {:rotate, 180}
  defp find_transform(:left, :bottom_rev), do: {:rotate, -90}
  defp find_transform(:top, :bottom_rev), do: :flip_horiz

  def apply_transform(rows, {:rotate, 180}) do
    rows
    |> reverse
    |> Enum.map(&reverse/1)
  end

  def apply_transform(rows, {:rotate, -90}) do
    rotate_left(rows, [])
  end

  def apply_transform(rows, :flip_horiz) do
    Enum.map(rows, &reverse/1)
  end

  defp rotate_left([[] | _], acc) do
    acc
    acc |> IO.inspect(label: "acc")
  end

  defp rotate_left(lists, acc) do
    heads = Enum.map(lists, &hd/1)
    # heads |> IO.inspect(label: "heads")
    tails = Enum.map(lists, &tl/1)
    # tails |> IO.inspect(label: "tails")
    rotate_left(tails, [heads | acc])
  end

  defp coords_from({x, y}, :left), do: {x - 1, y}
  defp coords_from({x, y}, :right), do: {x + 1, y}
  defp coords_from({x, y}, :top), do: {x, y - 1}

  defp unregister(registry, %{id: id, signatures: signatures}) do
    signatures |> IO.inspect(label: "signatures")

    signatures
    |> Enum.reduce(registry, fn {side, signature}, registry ->
      # side |> IO.inspect(label: "side")
      # id |> IO.inspect(label: "id")

      case Map.get(registry, signature) do
        [] -> exit({:empty, side, id})
        [{id, side}] -> Map.delete(registry, signature)
        list -> Map.put(registry, signature, List.keydelete(list, id, 0))
      end
    end)
  end
end
