defmodule AdventOfCode.Y23.Day18 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, :part_one) do
    input |> Enum.map(&parse_line_p1/1)
  end

  def parse_input(input, :part_two) do
    input |> Enum.map(&parse_line_p2/1)
  end

  defp parse_line_p1(line) do
    [dir, n, _color] = String.split(line, " ")

    dir =
      case dir do
        "R" -> :e
        "L" -> :w
        "U" -> :n
        "D" -> :s
      end

    n = String.to_integer(n)
    {dir, n}
  end

  defp parse_line_p2(line) do
    [_, _, color] = String.split(line, " ")
    {dir, n} = parse_color(color)

    {dir, n}
  end

  defp parse_color(<<"(#", n::binary-size(5), dir, ?)>>) do
    dir =
      case dir do
        ?0 -> :e
        ?2 -> :w
        ?3 -> :n
        ?1 -> :s
      end

    n = String.to_integer(n, 16)
    {dir, n}
  end

  def part_one(problem) do
    [_, last_lateral | _] = :lists.reverse(problem)
    {last_hdir, _} = last_lateral

    ranges =
      problem
      |> Enum.reduce({{0, 0}, [], last_hdir, :regular}, &dig/2)
      |> elem(1)

    {horizontals, verticals} =
      ranges
      # Keep only horizontal ranges
      |> Enum.split_with(fn
        {_, _, :vertical} -> false
        {_, _, _} -> true
      end)

    horizontals =
      horizontals
      # Keep them sorted by top position (y min)
      |> Enum.sort_by(fn
        {_, _..y, _} -> y
        {_.._, y, _} -> y
      end)
      # Reverse the negative ranges
      |> Enum.map(fn
        {a..b//-1, y, kind} -> {b..a, y, kind}
        {_.._//1, _, _} = fine -> fine
      end)

    [{_, _, ceiling_kind} | _] = horizontals
    true = ceiling_kind in [:regular, :goofy]

    {ceilings, bottoms} =
      Enum.split_with(horizontals, fn
        {_, _, ^ceiling_kind} -> true
        _ -> false
      end)

    rects = gen_rects(ceilings, bottoms, [])
    vert_rects = Enum.map(verticals, &vert_to_rect/1)
    rects = rects ++ vert_rects
    rects = split_rects(rects, [])
    Enum.map(rects, &rect_size/1) |> Enum.sum()
  end

  def part_two(problem) do
    part_one(problem)
  end

  defp split_rects([rect], acc) do
    [rect | acc]
  end

  defp split_rects([rect | rects], acc) do
    case check_split(rect, rects) do
      {:split, new_rects} -> split_rects(new_rects ++ rects, acc)
      :nosplit -> split_rects(rects, [rect | acc])
    end
  end

  defp split_rects([], acc) do
    acc
  end

  # covered
  defp check_split({xa..xo, ya..yo}, [{cxa..cxo, cya..cyo} | _])
       when cxa <= xa and cxo >= xo and cya <= ya and cyo >= yo do
    {:split, []}
  end

  # top-left corner splits the rectangle
  defp check_split({xa..xo, ya..yo} = rect, [{cxa.._cxo, cya.._cyo} | _])
       when cxa in xa..xo and cya in ya..yo do
    {:split, split_rect(rect, {cxa, cya})}
  end

  # top-right corner splits the rectangle
  defp check_split({xa..xo, ya..yo} = rect, [{_cxa..cxo, cya.._cyo} | _])
       when cxo in xa..xo and cya in ya..yo do
    {:split, split_rect(rect, {cxo, cya})}
  end

  # bottom-left corner splits the rectangle
  defp check_split({xa..xo, ya..yo} = rect, [{cxa.._cxo, _cya..cyo} | _])
       when cxa in xa..xo and cyo in ya..yo do
    {:split, split_rect(rect, {cxa, cyo})}
  end

  # bottom-right corner splits the rectangle
  defp check_split({xa..xo, ya..yo} = rect, [{_cxa..cxo, _cya..cyo} | _])
       when cxo in xa..xo and cyo in ya..yo do
    {:split, split_rect(rect, {cxo, cyo})}
  end

  defp check_split(current, [_nomatch | tail]) do
    check_split(current, tail)
  end

  defp check_split(_current, []) do
    :nosplit
  end

  defp split_rect({xa..xo, ya..yo}, {x, y}) do
    xaos = split_range_at(xa..xo, x)
    yaos = split_range_at(ya..yo, y)

    result =
      for xao <- xaos, yao <- yaos do
        {xao, yao}
      end

    result
  end

  defp split_range_at(a..b, a) do
    case b do
      ^a -> [a..a]
      _ -> [a..a, (a + 1)..b]
    end
  end

  defp split_range_at(a..b, b) do
    case a do
      ^b -> [b..b]
      _ -> [a..(b - 1), b..b]
    end
  end

  defp split_range_at(a..b, n) do
    [a..n, (n + 1)..b]
  end

  defp vert_to_rect({x, a..b//1, :vertical}) do
    {x..x, a..b//1}
  end

  defp vert_to_rect({x, a..b//-1, :vertical}) do
    {x..x, b..a//1}
  end

  defp rect_size({xa..xo//1, ya..yo//1}) do
    (xo - xa + 1) * (yo - ya + 1)
  end

  defp gen_rects([{xa..xo, y, kind} = range | ranges], bottoms, rects) when kind in [:regular, :goofy] do
    {bottoms_parts, _} = find_bottoms([xa..xo], y, bottoms, bottoms, []) |> Enum.unzip()

    rects = compute_rects(range, bottoms_parts, rects)

    # print_rects(rects)
    # Process.sleep(100)
    gen_rects(ranges, bottoms, rects)
  end

  defp gen_rects([], _, rects) do
    rects
  end

  defp compute_rects({_.._, ya, kind} = orig, [{xa..xo, yo} | bottoms], acc) when kind in [:regular, :goofy] do
    acc = [{xa..xo//1, ya..yo//1} | acc]
    compute_rects(orig, bottoms, acc)
  end

  defp compute_rects({_.._, _, _}, [], acc) do
    acc
  end

  defp find_bottoms([xa..xo = current | todo], top_y, [{x1..x2 = found_xr, found_y, _} = bottom | _], all_bottoms, acc)
       when (xa in x1..x2 or
               xo in x1..x2) and found_y > top_y do
    case split_range(current, found_xr) do
      {[subpart | []], rest} ->
        todo = rest ++ todo

        find_bottoms(todo, top_y, all_bottoms, all_bottoms, [{{subpart, found_y}, bottom} | acc])
    end
  end

  defp find_bottoms([], _, _, _, acc) do
    acc
  end

  defp find_bottoms(currents, top_y, [_nomatch | rest], all_bottoms, acc) do
    find_bottoms(currents, top_y, rest, all_bottoms, acc)
  end

  defp dig({dir, amount}, {{xstart, ystart} = start_pos, ranges, prev_hdir, last_kind}) do
    true = prev_hdir in [:w, :e]
    {xend, yend} = end_pos = translate(start_pos, dir, amount)

    {range, new_prev_hdir, new_last_kind} =
      case dir do
        horiz when horiz in [:e, :w] ->
          true = yend == ystart
          kind = if horiz == prev_hdir, do: last_kind, else: other_kind(last_kind)

          range = {xstart..xend, ystart, kind}
          {range, horiz, kind}

        vert when vert in [:n, :s] ->
          true = xend == xstart
          range = {xstart, ystart..yend, :vertical}
          {range, prev_hdir, last_kind}
      end

    new_ranges = [range | ranges]
    # print_ranges(new_ranges)
    # Process.sleep(100)
    {end_pos, new_ranges, new_prev_hdir, new_last_kind}
  end

  defp other_kind(:regular), do: :goofy
  defp other_kind(:goofy), do: :regular

  def translate({x, y}, :n, n), do: {x, y - n}
  def translate({x, y}, :s, n), do: {x, y + n}
  def translate({x, y}, :w, n), do: {x - n, y}
  def translate({x, y}, :e, n), do: {x + n, y}

  def split_range(ra..rz = range, sa..sz) when sa <= ra and sz >= rz do
    {[range], []}
  end

  def split_range(ra..rz, sa..sz) when sa >= ra and sz >= rz do
    {[sa..rz], [ra..(sa - 1)]}
  end

  def split_range(ra..rz, sa..sz) when sa <= ra and sz <= rz do
    {[ra..sz], [(sz + 1)..rz]}
  end

  def split_range(ra..rz, sa..sz) when sa >= ra and sz <= rz do
    {[sa..sz], [ra..(sa - 1), (sz + 1)..rz]}
  end
end
