defmodule AdventOfCode.Y23.Day22 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Stream.with_index(?A) |> Enum.map(&parse_line/1)
  end

  defp parse_line({line, id}) do
    [beg, fin] = String.split(line, "~")
    beg = parse_coords(beg)
    fin = parse_coords(fin)
    {<<id>>, beg, fin, cubes({beg, fin})}
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

  # def part_two(problem) do
  #   problem
  # end

  defp count_removables(bricks) do
    # Create two maps, on of supporter => [supported]
    # one of supported => [supporters]
    #
    # brick is removable if it has no supported or if all its suppored have multiple supporters

    sper_sped = Map.new(bricks, fn brick -> {id(brick), []} end)
    sped_sper = sper_sped

    {sper_sped, sped_sper} =
      for a <- bricks, b <- bricks, a != b, reduce: {sper_sped, sped_sper} do
        {sper_sped, sped_sper} ->
          cond do
            a |> on_top_of?(b) ->
              IO.puts("a is on top of b")
              sper_sped = Map.update!(sper_sped, id(b), &[id(a) | &1])
              sped_sper = Map.update!(sped_sper, id(a), &[id(b) | &1])
              {sper_sped, sped_sper}

            true ->
              {sper_sped, sped_sper}
          end
      end

    sper_sped |> dbg()

    {top_bricks, supporters} = Enum.split_with(sper_sped, fn {brick, supported} -> supported == [] end)
    top_bricks |> dbg()

    removable_supporters =
      Enum.filter(supporters, fn {brick, supported} ->
        Enum.all?(supported, fn above ->
          case Map.fetch!(sped_sper, above) do
            [^brick] -> false
            [_, _ | _] -> true
          end
        end)
      end)

    top_bricks |> dbg()
    supporters |> dbg()
    sped_sper |> dbg()
    removable_supporters |> dbg()

    length(removable_supporters) + length(top_bricks)
  end

  defp loop_fall(bricks) do
    loop_fall(bricks, [])
  end

  defp loop_fall(unstable, stable) do
    length(unstable) |> IO.inspect(label: ~S/length(unstable)/)

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

  defp on_top_of?({_, _, _, top_cubes} = top_brick, {_, _, _, bottom_cubes} = bottom_brick) do
    # for now we use a slow method, just compute all the cubes and check if one
    # is above another

    Enum.any?(top_cubes, fn top -> Enum.any?(bottom_cubes, fn bottom -> on_top_of_cube?(top, bottom) end) end)
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
end
