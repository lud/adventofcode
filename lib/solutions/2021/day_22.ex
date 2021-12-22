defmodule Aoe.Y21.Day22 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    Enum.map(input, &parse_line/1)
  end

  @re_line ~r/^(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/
  defp parse_line(line) do
    [onoff, xi, xo, yi, yo, zi, zo] = Regex.run(@re_line, line, capture: :all_but_first)

    flag = String.to_existing_atom(onoff)

    {
      flag,
      {String.to_integer(xi), String.to_integer(xo)},
      {String.to_integer(yi), String.to_integer(yo)},
      {String.to_integer(zi), String.to_integer(zo)}
    }
  end

  def part_one(lines) do
    lines
    |> Enum.map(&shrink_zone/1)
    |> Enum.filter(&is_tuple/1)
    |> part_two()
  end

  def part_two(lines) do
    lines
    |> Enum.reduce([], &insert_block/2)
    |> Enum.reduce(0, &sum_blocks/2)
  end

  defp sum_blocks({:off, _, _, _}, acc), do: acc

  defp sum_blocks({:on, {xi, xo}, {yi, yo}, {zi, zo}}, acc) do
    acc + (xo - xi + 1) * (yo - yi + 1) * (zo - zi + 1)
  end

  defp shrink_zone({flag, {xi, xo}, {yi, yo}, {zi, zo}}) do
    if xi > 50 || xi < -50 ||
         yi > 50 || yi < -50 ||
         zi > 50 || zi < -50 ||
         xo > 50 || xo < -50 ||
         yo > 50 || yo < -50 ||
         zo > 50 || zo < -50 do
      :discard
    else
      {flag, {xi, xo}, {yi, yo}, {zi, zo}}
    end
  end

  def insert_block(block, [candidate | tail] = world) do
    {_, {xi, xo}, {yi, yo}, {zi, zo}} = block
    {_, {cxi, cxo}, {cyi, cyo}, {czi, czo}} = candidate

    cond do
      contains(block, candidate) -> insert_block(block, tail)
      external(block, candidate) -> [candidate | insert_block(block, tail)]
      over_right(xi, cxi, cxo) -> insert_block(block, split(candidate, :xi, xi) ++ tail)
      over_left(xo, cxi, cxo) -> insert_block(block, split(candidate, :xo, xo) ++ tail)
      over_right(yi, cyi, cyo) -> insert_block(block, split(candidate, :yi, yi) ++ tail)
      over_left(yo, cyi, cyo) -> insert_block(block, split(candidate, :yo, yo) ++ tail)
      over_right(zi, czi, czo) -> insert_block(block, split(candidate, :zi, zi) ++ tail)
      over_left(zo, czi, czo) -> insert_block(block, split(candidate, :zo, zo) ++ tail)
      over_right(cxi, xi, xo) -> insert_multi(split(block, :xi, cxi), world)
      over_left(cxo, xi, xo) -> insert_multi(split(block, :xo, cxo), world)
      over_right(cyi, yi, yo) -> insert_multi(split(block, :yi, cyi), world)
      over_left(cyo, yi, yo) -> insert_multi(split(block, :yo, cyo), world)
      over_right(czi, zi, zo) -> insert_multi(split(block, :zi, czi), world)
      over_left(czo, zi, zo) -> insert_multi(split(block, :zo, czo), world)
    end
  end

  def insert_block(block, []), do: [block]

  defp insert_multi(blocks, world) do
    Enum.reduce(blocks, world, fn block, world ->
      # IO.puts("insert shard: #{inspect(block)}")
      insert_block(block, world)
    end)
  end

  defp split({flag, {xi, xo}, ys, zs}, :xi, x) when xi != xo do
    # keep x in the right-hand part
    [{flag, {xi, x - 1}, ys, zs}, {flag, {x, xo}, ys, zs}]
    |> filter_invalid()
  end

  defp split({flag, {xi, xo}, ys, zs}, :xo, x) when xi != xo do
    # keep x in the left part
    [{flag, {xi, x}, ys, zs}, {flag, {x + 1, xo}, ys, zs}]
    |> filter_invalid()
  end

  defp split({flag, xs, {yi, yo}, zs}, :yi, y) when yi != yo do
    [{flag, xs, {yi, y - 1}, zs}, {flag, xs, {y, yo}, zs}]
    |> filter_invalid()
  end

  defp split({flag, xs, {yi, yo}, zs}, :yo, y) when yi != yo do
    [{flag, xs, {yi, y}, zs}, {flag, xs, {y + 1, yo}, zs}]
    |> filter_invalid()
  end

  defp split({flag, xs, ys, {zi, zo}}, :zi, z) when zi != zo do
    [{flag, xs, ys, {zi, z - 1}}, {flag, xs, ys, {z, zo}}]
    |> filter_invalid()
  end

  defp split({flag, xs, ys, {zi, zo}}, :zo, z) when zi != zo do
    [{flag, xs, ys, {zi, z}}, {flag, xs, ys, {z + 1, zo}}]
    |> filter_invalid()
  end

  defp filter_invalid([{_, {xi, xo}, {yi, yo}, {zi, zo}} = block | rest])
       when xi <= xo and yi <= yo and zi <= zo do
    [block | filter_invalid(rest)]
  end

  defp filter_invalid([]), do: []

  defp over_right(v, min, max) when v > min and v <= max, do: true
  defp over_right(_, _, _), do: false
  defp over_left(v, min, max) when v >= min and v < max, do: true
  defp over_left(_, _, _), do: false

  defp contains({_, {xi, xo}, {yi, yo}, {zi, zo}}, {_, {cxi, cxo}, {cyi, cyo}, {czi, czo}})
       when xi <= cxi and xo >= cxo and
              yi <= cyi and yo >= cyo and
              zi <= czi and zo >= czo do
    true
  end

  defp contains(_, _) do
    false
  end

  defp external({_, {xi, xo}, {yi, yo}, {zi, zo}}, {_, {cxi, cxo}, {cyi, cyo}, {czi, czo}})
       when xo < cxi or xi > cxo or
              yo < cyi or yi > cyo or
              zo < czi or zi > czo do
    true
  end

  defp external(_, _) do
    false
  end
end
