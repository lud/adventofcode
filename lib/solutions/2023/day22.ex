defmodule AdventOfCode.Y23.Day22 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Stream.with_index(100_001) |> Stream.map(&parse_line/1)
  end

  defp parse_line({line, id}) do
    [beg, fin] = String.split(line, "~")
    beg = parse_coords(beg)
    fin = parse_coords(fin)

    {id, beg, fin, cubes({beg, fin})}
  end

  defp parse_coords(coords) do
    [x, y, z] = String.split(coords, ",")

    {
      String.to_integer(x),
      String.to_integer(y),
      String.to_integer(z)
    }
  end

  def part_one(bricks) do
    bricks
    |> Enum.sort_by(fn {_id, {_, _, zbeg}, {_, _, zfin}, _} -> min(zbeg, zfin) end)
    |> loop_fall()
    |> count_removables()
  end

  defp loop_fall(bricks) do
    loop_fall(bricks, [])
  end

  defp loop_fall(unstable, stable) do
    case stabilize(unstable, stable) do
      {[], all_stable} ->
        all_stable

      {unstable, stable} ->
        unstable = Enum.map(unstable, &stepdown/1)
        loop_fall(unstable, stable)
    end
  end

  defp stepdown({id, {xbeg, ybeg, zbeg}, {xfin, yfin, zfin}, cubes}) do
    {id, {xbeg, ybeg, zbeg - 1}, {xfin, yfin, zfin - 1}, stepdown_cubes(cubes)}
  end

  defp stabilize(unstable, stable) do
    case Enum.split_with(unstable, fn brick -> not stable?(brick, stable) end) do
      {^unstable, []} -> {unstable, stable}
      {unstable, [_ | _] = new_stable} -> stabilize(unstable, new_stable ++ stable)
    end
  end

  # stable if it touches the ground
  defp stable?({_id, {_, _, zbeg}, {_, _, zfin}, _cubes}, _stable) when zbeg == 1 when zfin == 1 do
    true
  end

  # stable if it touches a stable brick
  defp stable?(brick, stable) do
    Enum.any?(stable, &on_top_of?(brick, &1))
  end

  defp on_top_of?(
         {_, {xabeg, yabeg, _}, {xafin, yafin, _}, top_cubes},
         {_, {xabotbeg, yabotbeg, _}, {xabotfin, yabotfin, _}, bottom_cubes}
       )
       when xabeg in xabotbeg..xabotfin or
              xafin in xabotbeg..xabotfin or
              (yabeg in yabotbeg..yabotfin or
                 yafin in yabotbeg..yabotfin) do
    # for now we use a slow method, just compute all the cubes and check if one
    # is above another

    Enum.any?(top_cubes, fn top -> Enum.any?(bottom_cubes, fn bottom -> on_top_of_cube?(top, bottom) end) end)
  end

  defp on_top_of?(_, _) do
    false
  end

  defp on_top_of_cube?({x, y, z}, {x2, y2, z2}) do
    x == x2 and y == y2 and z == z2 + 1
  end

  defp cubes({{xbeg, ybeg, zbeg}, {xfin, yfin, zfin}}) do
    for x <- xbeg..xfin, y <- ybeg..yfin, z <- zbeg..zfin, do: {x, y, z}
  end

  defp stepdown_cubes(cubes) do
    Enum.map(cubes, fn {x, y, z} -> {x, y, z - 1} end)
  end

  defp id({id, _, _, _}), do: id

  defp build_relations(bricks) do
    # Create two maps, on of supporter => [supported]
    # one of supported => [supporters]

    sped_sper = Map.new(bricks, fn brick -> {id(brick), []} end)

    _sped_sper =
      for sped <- bricks, sper <- bricks, sped != sper, reduce: sped_sper do
        sped_sper ->
          if sped |> on_top_of?(sper) do
            sped_sper = Map.update!(sped_sper, id(sped), &[id(sper) | &1])
            sped_sper
          else
            sped_sper
          end
      end
  end

  defp count_removables(bricks) do
    sped_sper = build_relations(bricks)

    # brick is removable if it is not found as the single supporter of another
    single_supporters =
      Enum.flat_map(sped_sper, fn
        {_brick, [single]} -> [single]
        _ -> []
      end)
      |> Enum.uniq()

    length(bricks) - length(single_supporters)
  end

  def part_two(bricks) do
    bricks
    |> Enum.sort_by(fn {_id, {_, _, zbeg}, {_, _, zfin}, _} -> min(zbeg, zfin) end)
    |> loop_fall()
    |> build_relations()
    |> count_chains()
  end

  defp count_chains(sped_sper) do
    sped_sper = Map.new(sped_sper, fn {id, spers} -> {id, MapSet.new(spers)} end)

    sped_sper
    |> Enum.map(fn {id, _} -> count_chain(MapSet.new([id]), sped_sper) end)
    |> Enum.sum()
  end

  defp count_chain(moved, speds) do
    Enum.reduce(speds, {moved, false}, fn
      {_id, %MapSet{map: m}}, {moved, changed?} when 0 == map_size(m) ->
        {moved, changed?}

      {id, spers}, {moved, changed?} ->
        if MapSet.subset?(spers, moved) do
          {MapSet.put(moved, id), _changed? = true}
        else
          {moved, changed?}
        end
    end)
    |> case do
      {new_moved, true = _changed?} -> count_chain(new_moved, Map.drop(speds, MapSet.to_list(new_moved)))
      {new_moved, false} -> MapSet.size(new_moved) - 1
    end
  end
end
