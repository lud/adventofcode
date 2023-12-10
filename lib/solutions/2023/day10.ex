defmodule AdventOfCode.Y23.Day10 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(lines, _part) do
    Grid.parse_stream(lines, &parse_char/1)
  end

  @pipes [:S, :F, :"7", :J, :|, :L, :-]

  defp parse_char("."), do: :ignore
  defp parse_char("S"), do: {:ok, :S}
  defp parse_char("F"), do: {:ok, :F}
  defp parse_char("7"), do: {:ok, :"7"}
  defp parse_char("J"), do: {:ok, :J}
  defp parse_char("|"), do: {:ok, :|}
  defp parse_char("L"), do: {:ok, :L}
  defp parse_char("-"), do: {:ok, :-}

  def part_one(grid) do
    {start_xy, :S} = Enum.find(grid, fn {_, v} -> v == :S end)

    {dir, next_node} =
      start_xy
      |> starting_neighbours(grid)
      |> hd()

    {count, _path} = follow_path_to(dir, next_node, 1, start_xy, [next_node], grid)

    div(count, 2)
  end

  defp follow_path_to(_last_direction, {target, _pipe}, count, target, collected, _grid) do
    {count, collected}
  end

  defp follow_path_to(last_direction, {xy, pipe} = _node, count, target, collected, grid) do
    next_dir = follow_pipe(last_direction, pipe)
    next_xy = move(xy, next_dir)
    next_pipe = Map.fetch!(grid, next_xy)
    next_node = {next_xy, next_pipe}
    follow_path_to(next_dir, next_node, count + 1, target, [next_node | collected], grid)
  end

  def part_two(grid) do
    {start_xy, :S} = Enum.find(grid, fn {_, v} -> v == :S end)

    {dir, {next_xy, _} = next_node} =
      start_xy
      |> starting_neighbours(grid)
      |> hd()

    {_, path} = follow_path_to(dir, next_node, 1, start_xy, [next_node], grid)

    [{^start_xy, :S}, {prev_xy, _} = _prev_node | _] = path

    # From start, what are the directions leading to our two loop starts
    prev_xy_direction = [:n, :s, :w, :e] |> Enum.find(&(move(start_xy, &1) == prev_xy))
    next_xy_direction = [:n, :s, :w, :e] |> Enum.find(&(move(start_xy, &1) == next_xy))
    start_type = Enum.find(@pipes, fn t -> links_to?(t, prev_xy_direction) and links_to?(t, next_xy_direction) end)

    # Replace the grid with the loop nodes only
    grid = Map.new(path)
    grid = Map.put(grid, start_xy, start_type)

    # Going over the map line by line.  For each line start at west and go over
    # positions, changing the side beween :in and :out if we cross a pipe, and
    # counting the empty positions when we are on the :in side.

    xa = 0
    ya = 0
    xo = Grid.max_x(grid)
    yo = Grid.max_y(grid)
    {xo, yo}

    count =
      Enum.reduce(ya..yo, 0, fn y, ext_cout ->
        {_, count, _} =
          Enum.reduce(xa..xo, {:out, ext_cout, nil}, fn x, {side, count, cut} ->
            pos = {x, y}

            case {cut, Map.get(grid, pos, nil), side} do
              # Keeping same side over dead ends or horizontal pipes
              {:F, :J, side} -> {side, count, nil}
              {:L, :"7", side} -> {side, count, nil}
              {cut, :-, side} -> {side, count, cut}
              # crossing pipes
              {:F, :"7", side} -> {otherside(side), count, nil}
              {:L, :J, side} -> {otherside(side), count, nil}
              {nil, :|, side} -> {otherside(side), count, nil}
              {nil, :F, side} -> {otherside(side), count, :F}
              {nil, :L, side} -> {otherside(side), count, :L}
              # counting inside positions, ignoring outside positions
              {_, nil, :in} -> {:in, count + 1, nil}
              {_, nil, :out} -> {:out, count, nil}
            end
          end)

        count
      end)

    count
  end

  defp starting_neighbours(xy, grid) do
    Enum.flat_map([:n, :e, :s, :w], fn dir -> starting_neighbour_with_direction(xy, dir, grid) end)
  end

  defp starting_neighbour_with_direction(xy, direction, grid) do
    next_xy = move(xy, direction)

    case {direction, Map.get(grid, next_xy)} do
      {:w, valid} when valid in [:-, :F, :L] -> [{:w, {next_xy, valid}}]
      {:e, valid} when valid in [:-, :J, :"7"] -> [{:e, {next_xy, valid}}]
      {:s, valid} when valid in [:|, :J, :L] -> [{:s, {next_xy, valid}}]
      {:n, valid} when valid in [:|, :F, :"7"] -> [{:n, {next_xy, valid}}]
      _ -> []
    end
  end

  # follow_pipe(:e, :-, xy) means "coming from the east, arriving at "-", where
  # to go next? we contiue east in this example.

  defp follow_pipe(:e, :"7"), do: :s
  defp follow_pipe(:e, :J), do: :n
  defp follow_pipe(:n, :"7"), do: :w
  defp follow_pipe(:n, :F), do: :e
  defp follow_pipe(:s, :J), do: :w
  defp follow_pipe(:s, :L), do: :e
  defp follow_pipe(:w, :F), do: :s
  defp follow_pipe(:w, :L), do: :n
  defp follow_pipe(d, :-), do: d
  defp follow_pipe(d, :|), do: d

  def move({x, y}, :n), do: {x, y - 1}
  def move({x, y}, :s), do: {x, y + 1}
  def move({x, y}, :w), do: {x - 1, y}
  def move({x, y}, :e), do: {x + 1, y}

  links = [
    {:F, [:s, :e]},
    {:"7", [:w, :s]},
    {:J, [:w, :n]},
    {:|, [:n, :s]},
    {:L, [:n, :e]},
    {:-, [:e, :w]}
  ]

  for {pipe, dirs} <- links, dir <- dirs do
    defp links_to?(unquote(pipe), unquote(dir)), do: true
  end

  defp links_to?(_, _), do: false

  defp otherside(:out), do: :in
  defp otherside(:in), do: :out
end
