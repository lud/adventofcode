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

    {id, beg, fin}
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
    |> Enum.sort_by(fn {_id, {_, _, zbeg}, {_, _, zfin}} -> min(zbeg, zfin) end)
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

  defp stepdown({id, {xbeg, ybeg, zbeg}, {xfin, yfin, zfin}}) do
    {id, {xbeg, ybeg, zbeg - 1}, {xfin, yfin, zfin - 1}}
  end

  defp stabilize(unstable, stable) do
    case Enum.split_with(unstable, fn brick -> not stable?(brick, stable) end) do
      {^unstable, []} -> {unstable, stable}
      {unstable, [_ | _] = new_stable} -> stabilize(unstable, new_stable ++ stable)
    end
  end

  # stable if it touches the ground
  defp stable?({_id, {_, _, zbeg}, {_, _, zfin}}, _stable) when zbeg == 1 when zfin == 1 do
    true
  end

  # stable if it touches a stable brick
  defp stable?(brick, stable) do
    Enum.any?(stable, &on_top_of?(brick, &1))
  end

  defp on_top_of?(
         {_, {xdeb, ydeb, zdeb}, {xfin, yfin, zfin}},
         {_, {xbotdeb, ybotdeb, zbotdeb}, {xbotfin, ybotfin, zbotfin}}
       )
       when (zdeb == zbotdeb + 1 or
               zfin == zbotfin + 1 or
               zdeb == zbotfin + 1 or
               zfin == zbotdeb + 1) and
              (xdeb in xbotdeb..xbotfin or
                 xfin in xbotdeb..xbotfin or
                 xbotdeb in xdeb..xfin or
                 xbotfin in xdeb..xfin) and
              (ydeb in ybotdeb..ybotfin or
                 yfin in ybotdeb..ybotfin or
                 ybotdeb in ydeb..yfin or
                 ybotfin in ydeb..yfin) do
    true
  end

  defp on_top_of?(_, _) do
    false
  end

  defp id({id, _, _}), do: id

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
