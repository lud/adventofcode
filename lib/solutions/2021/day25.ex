defmodule AdventOfCode.Solutions.Y21.Day25 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input = Enum.to_list(input)
    yo = length(input) - 1
    xo = (hd(input) |> byte_size) - 1
    {xo, yo}

    grid =
      input
      |> Enum.with_index()
      |> Enum.map(fn {line, y} ->
        parse_line(line, y)
      end)
      |> Enum.reduce(%{}, fn map1, map2 -> Map.merge(map1, map2, &raise_merge/3) end)

    {{xo, yo}, grid}
  end

  defp raise_merge(key, _, _) do
    raise "duplicate key #{key}"
  end

  defp parse_line(line, y) do
    line
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn
      {?., _}, acc -> acc
      {?v, x}, acc -> Map.put(acc, {x, y}, :v)
      {?>, x}, acc -> Map.put(acc, {x, y}, :>)
    end)
  end

  def part_one({{xo, yo}, grid}) do
    turns = Stream.iterate(1, &(&1 + 1))

    Enum.reduce_while(turns, grid, fn turn, grid ->
      {moved, grid} = move_cucumbers({xo, yo}, grid)

      case {moved, grid} do
        {0, _} -> {:halt, turn}
        {_n, new_grid} -> {:cont, new_grid}
      end
    end)
  end

  defp move_cucumbers({xo, yo}, grid) do
    # move east facing
    {moved, grid} =
      Enum.reduce(grid, {0, %{}}, fn
        {coords, :v}, {moved, new_grid} ->
          {moved, Map.put(new_grid, coords, :v)}

        {coords, :>}, {moved, new_grid} ->
          case move(coords, :>, grid, {xo, yo}) do
            {:ok, new_coords} ->
              {moved + 1, Map.put(new_grid, new_coords, :>)}

            :nope ->
              {moved, Map.put(new_grid, coords, :>)}
          end
      end)

    # move south facing
    Enum.reduce(grid, {moved, %{}}, fn
      {coords, :>}, {moved, new_grid} ->
        {moved, Map.put(new_grid, coords, :>)}

      {coords, :v}, {moved, new_grid} ->
        case move(coords, :v, grid, {xo, yo}) do
          {:ok, new_coords} ->
            {moved + 1, Map.put(new_grid, new_coords, :v)}

          :nope ->
            {moved, Map.put(new_grid, coords, :v)}
        end
    end)
  end

  defp move({x, y}, :v, grid, {_xo, yo}) do
    next_coords = {x, wrap(y + 1, yo)}

    if free?(grid, next_coords) do
      {:ok, next_coords}
    else
      :nope
    end
  end

  defp move({x, y}, :>, grid, {xo, _yo}) do
    next_coords = {wrap(x + 1, xo), y}

    if free?(grid, next_coords) do
      {:ok, next_coords}
    else
      :nope
    end
  end

  defp free?(grid, next_coords) do
    not Map.has_key?(grid, next_coords)
  end

  defp wrap(coord, max_coord) when coord <= max_coord,
    do: coord

  defp wrap(coord, max_coord) when coord == max_coord + 1,
    do: 0
end
