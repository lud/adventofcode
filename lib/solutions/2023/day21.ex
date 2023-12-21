defmodule AdventOfCode.Y23.Day21 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, :duplicate) do
    grid = Grid.parse_stream(input, &{:ok, &1})

    {xa, xo, ya, yo} = Grid.bounds(grid) |> dbg()

    start =
      Enum.find_value(grid, fn
        {xy, "S"} -> xy
        _ -> false
      end)

    copy =
      Map.new(grid, fn
        {xy, "S"} -> {xy, "."}
        {{0, y}, "."} -> {{0, y}, "*"}
        {{x, 0}, "."} -> {{x, 0}, "*"}
        {{^xo, y}, "."} -> {{xo, y}, "*"}
        {{x, ^yo}, "."} -> {{x, yo}, "*"}
        other -> other
      end)

    top = Map.new(copy, fn {{x, y}, v} -> {{x, y - yo - 1}, v} end)
    top_left = Map.new(copy, fn {{x, y}, v} -> {{x - xo - 1, y - yo - 1}, v} end)
    top_right = Map.new(copy, fn {{x, y}, v} -> {{x + xo + 1, y - yo - 1}, v} end)

    left = Map.new(copy, fn {{x, y}, v} -> {{x - xo - 1, y}, v} end)
    right = Map.new(copy, fn {{x, y}, v} -> {{x + xo + 1, y}, v} end)

    bottom = Map.new(copy, fn {{x, y}, v} -> {{x, y + yo + 1}, v} end)
    bottom_left = Map.new(copy, fn {{x, y}, v} -> {{x - xo - 1, y + yo + 1}, v} end)
    bottom_right = Map.new(copy, fn {{x, y}, v} -> {{x + xo + 1, y + yo + 1}, v} end)

    Enum.reduce([top, top_left, top_right, left, right, bottom, bottom_left, bottom_right], grid, &Map.merge/2)
  end

  def parse_input(input, _part) do
    Grid.parse_stream(input, &{:ok, &1})
  end

  def part_one(grid) when is_map(grid) do
    part_one({grid, 64})
  end

  def part_one({grid, max_steps}) do
    # Note
    #
    # We do not want the totality of reachable tiles in 64 steps or less, only
    # those that can be reached after exactly 64 steps.
    pos =
      Enum.find_value(grid, fn
        {xy, "S"} = start -> xy
        _ -> false
      end)

    grid = Map.put(grid, pos, ".")

    positions = loop([pos], 1, max_steps, grid)
    length(positions)
  end

  defp loop(open, step, max_steps, grid) when step > max_steps do
    open
  end

  defp loop(open, step, max_steps, grid) do
    new_open =
      Enum.flat_map(open, fn pos ->
        pos
        |> Grid.cardinal4()
        |> Enum.map(&{&1, Map.get(grid, &1)})
        |> Enum.filter(fn
          {xy, "."} -> true
          {xy, "*"} -> true
          _ -> false
        end)
        |> Enum.map(&elem(&1, 0))
      end)
      |> Enum.uniq()

    loop(new_open, step + 1, max_steps, grid)
  end

  def part_two(grid) when is_map(grid) do
    part_two({grid, 26_501_365})
  end

  def part_two({grid, max_steps}) do
    # This solution will only work with the actual input. It has a clear path
    # in the caridnal directions over the starting point.

    {x_start, y_start} =
      Enum.find_value(grid, fn
        {xy, "S"} -> xy
        _ -> false
      end)

    {xa, xo, ya, yo} = Grid.bounds(grid)

    # the map is a square
    square_size = yo - ya + 1
    ^square_size = xo - xa + 1

    # we are in the middle
    n_tiles_side = x_start - xa
    n_tiles_side |> dbg()
    ^n_tiles_side = xo - x_start

    ^n_tiles_side = y_start - ya
    ^n_tiles_side = yo - y_start

    # We know that when we move the discovered tiles form a diamond shape over
    # time.  And the input conveniently has a diamond shaped band with no rocks.
    # So we assume that this is so we can just multiply the diamond shape size
    # and we should end up there.
    #
    # So, going north for 26,501,365 steps, where would we end up?

    # After n_tiles_side steps we are at the top of the map
    remain_steps = max_steps - n_tiles_side

    max_steps |> IO.inspect(label: ~S/   max_steps/)
    remain_steps |> IO.inspect(label: ~S/remain_steps/)

    # we can get over the map full times
    remain_steps = rem(remain_steps, square_size)

    # convenintly, we reach the top of the map as there is no more step to walk
    # past that
    0 = remain_steps

    # As the map is a square, this holds true for the width too:
    0 = (max_steps - n_tiles_side) |> rem(square_size)

    # How many grids do we cover ?
    #
    # The shape is a diamond so the tiling for the repeated grid will also be a
    # diamond, but with 3 grids at each pike, since the diamond shape of the
    # garden slots cuts through the middle of the grid sides:
    # * For each row TOP OF the starting grid, we have 1 grid on the LEFT with
    #   the bottom right angle (1/8 of surface) filled
    # * For each row over the starting grid, we have 1 grid on the RIGHT with
    #   the bottom left angle (1/8 of surface) filled
    # * Same with rows BELOW the starting grid, with the top angles filled.
    #
    # So for each count of "grid ray" - 1 (the number of added grids in one
    # direction), we have 4 angles filled
    #
    #
    # Now we cannot just count the grids or whatever because as the pattern of
    # filling switches positions each step, there are two possible fillings,
    # those where the slots touches the border in center, and the opposite
    # filling.
    #
    # So let's generate a grid duplicated, 3x3 with the original grid in center.
    # The "*" are used to see the boundaries in a debug file, they count as
    # dots.
    copy =
      Map.new(grid, fn
        {xy, "S"} -> {xy, "."}
        {{0, y}, "."} -> {{0, y}, "*"}
        {{x, 0}, "."} -> {{x, 0}, "*"}
        {{^xo, y}, "."} -> {{xo, y}, "*"}
        {{x, ^yo}, "."} -> {{x, yo}, "*"}
        other -> other
      end)

    top = Map.new(copy, fn {{x, y}, v} -> {{x, y - yo - 1}, v} end)
    top_left = Map.new(copy, fn {{x, y}, v} -> {{x - xo - 1, y - yo - 1}, v} end)
    top_right = Map.new(copy, fn {{x, y}, v} -> {{x + xo + 1, y - yo - 1}, v} end)

    left = Map.new(copy, fn {{x, y}, v} -> {{x - xo - 1, y}, v} end)
    right = Map.new(copy, fn {{x, y}, v} -> {{x + xo + 1, y}, v} end)

    bottom = Map.new(copy, fn {{x, y}, v} -> {{x, y + yo + 1}, v} end)
    bottom_left = Map.new(copy, fn {{x, y}, v} -> {{x - xo - 1, y + yo + 1}, v} end)
    bottom_right = Map.new(copy, fn {{x, y}, v} -> {{x + xo + 1, y + yo + 1}, v} end)

    expanded_grid =
      Enum.reduce([top, top_left, top_right, left, right, bottom, bottom_left, bottom_right], grid, &Map.merge/2)

    # Now we will run the simulation and get our different fillings. But how
    # many steps should we run. Well, 1 grid heigt plus the steps to reach the
    # side of the center grid, as we know the solution step reaches the side
    # too.

    sim_steps = n_tiles_side + square_size
    positions = loop([{x_start, y_start}], 1, sim_steps, expanded_grid)

    debug =
      expanded_grid
      |> Map.merge(Map.new(positions, fn xy -> {xy, "O"} end))
      |> Grid.format_map()

    File.write!("/tmp/debug.txt", debug)
  end

  def pyramid_count(height) do
    # the left part contains the central column and is just the formula for
    # 1+2+3+4+..+n
    left = div(height * (height + 1), 2)
    # the left part does not contain the central column
    right = left - height
    left + right
  end

  def diamond_count(ray) do
    # the ray contains the central pixel, so the top part does
    top = pyramid_count(ray)
    bottom_row = ray * 2 - 1
    bottom = top - bottom_row
    top + bottom
  end
end
