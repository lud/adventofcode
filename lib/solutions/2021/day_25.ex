defmodule Aoe.Y21.Day25 do
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
    input = Enum.to_list(input)
    input |> IO.inspect(label: "input")
    length(input) |> IO.inspect(label: "length(input)")
    yo = length(input) - 1
    xo = (hd(input) |> String.to_charlist() |> length()) - 1
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

    # print_grid(grid, xo, yo)

    Enum.reduce_while(turns, grid, fn turn, grid ->
      IO.puts("turn #{turn}")
      {moved, grid} = move_cucumbers({xo, yo}, grid)
      # print_grid(grid, xo, yo)

      case {moved, grid} do
        {0, _} ->
          {:halt, turn}

        {n, new_grid} ->
          IO.puts(" => moved: #{n}")
          {:cont, new_grid}
      end
    end)
  end

  defp print_grid(grid, xo, yo) do
    for y <- 0..yo do
      for x <- 0..xo do
        case Map.get(grid, {x, y}) do
          nil -> IO.write(".")
          :v -> IO.write("v")
          :> -> IO.write(">")
        end
      end

      IO.write("\n")
    end
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

  defp move({x, y}, :v, grid, {xo, yo}) do
    next_coords = {x, wrap(y + 1, yo)}

    if free?(grid, next_coords) do
      {:ok, next_coords}
    else
      :nope
    end
  end

  defp move({x, y}, :>, grid, {xo, yo}) do
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

  def part_two(problem) do
    problem
  end
end
