defmodule AdventOfCode.Solutions.Y25.Day09 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.map(fn line ->
      [x, y] = String.split(line, ",", parts: 2)
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  def part_one(tiles) do
    Enum.reduce(all_rectangles_w_area(tiles), 0, fn {_, area}, best -> max(area, best) end)
  end

  defp area({xa, ya}, {xb, yb}) do
    (abs(xa - xb) + 1) * (abs(ya - yb) + 1)
  end

  def part_two(tiles) do
    {h_segments, v_segments} = build_segments([List.last(tiles) | tiles])

    tiles
    |> all_rectangles_w_area()
    |> Enum.filter(fn {rect, _} -> within_bounds?(rect, h_segments, v_segments) end)
    |> Enum.reduce(0, fn {_, area}, best -> max(area, best) end)
  end

  defp build_segments(tiles, horizontal \\ [], vertical \\ [])

  defp build_segments([{x, ya}, {x, yb} = b | rest], horizontal, vertical) do
    build_segments(
      [b | rest],
      horizontal,
      [{x, min(ya, yb), max(ya, yb)} | vertical]
    )
  end

  defp build_segments([{xa, y}, {xb, y} = b | rest], horizontal, vertical) do
    build_segments(
      [b | rest],
      [{y, min(xa, xb), max(xa, xb)} | horizontal],
      vertical
    )
  end

  defp build_segments([_], h, v) do
    {h, v}
  end

  defp all_rectangles_w_area([h | [_ | _] = t]) do
    Enum.map(t, &{rect(h, &1), area(h, &1)}) ++ all_rectangles_w_area(t)
  end

  defp all_rectangles_w_area([_]) do
    []
  end

  defp rect({x1, y1}, {x2, y2}) do
    {min(x1, x2), max(x1, x2), min(y1, y2), max(y1, y2)}
  end

  defp within_bounds?(rect, h_segments, v_segments) do
    not crosses_horizontal?(rect, h_segments) && not crosses_vertical?(rect, v_segments)
  end

  defp crosses_horizontal?(rect, h_segments) do
    {xa, xo, ya, yo} = rect

    Enum.any?(h_segments, fn h_segment ->
      {y, xha, xho} = h_segment
      y > ya and y < yo and not (xho <= xa or xha >= xo)
    end)
  end

  defp crosses_vertical?(rect, v_segments) do
    {xa, xo, ya, yo} = rect

    Enum.any?(v_segments, fn v_segment ->
      {x, yha, yho} = v_segment
      x > xa and x < xo and not (yho <= ya or yha >= yo)
    end)
  end
end
