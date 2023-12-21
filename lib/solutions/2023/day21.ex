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
        |> Enum.filter(fn
          xy ->
            case Map.get(grid, xy) do
              "." -> true
              "*" -> true
              _ -> false
            end
        end)
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
    width = xo - xa + 1
    ^width = xo + 1

    height = yo - ya + 1
    ^height = yo + 1

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

    # we can get got to the top of the next map as long as steps remain
    # convenintly, we reach the top of the map when there is no more step to walk
    # past that
    0 = rem(remain_steps, square_size)

    # As the map is a square, this holds true for the width too:
    0 = (max_steps - n_tiles_side) |> rem(square_size)

    # Short ray is the number of additional grid in ce central column on top of
    # the central grid. (so counting just one direction)
    short_ray = div(remain_steps, square_size)

    short_ray |> IO.inspect(label: ~S/short_ray/)

    # The shape is a diamond so the tiling for the repeated grid will also be a
    # diamond, but with 3 grids at each pike, since the diamond shape of the
    # garden slots cuts through the middle of the grid sides.
    #
    # * The topmost row will have bottom part full and top part diamond, with
    #   "regular" fill.
    # * All rows except the topmost and center will have a 1/8 grid with
    #   "alternate" fill, on the extreme left and extreme right.
    # * All rows except the topmost and center will have a 7/8 grid with
    #   "regular" fill, on the left and on the right, next to the previous ones.
    # * Then each row will alternate between "alternate" and "regular" fill
    #   until the center.
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

    top = Map.new(copy, fn {{x, y}, v} -> {{x, y - height}, v} end)
    top_left = Map.new(copy, fn {{x, y}, v} -> {{x - width, y - height}, v} end)
    top_right = Map.new(copy, fn {{x, y}, v} -> {{x + width, y - height}, v} end)

    left = Map.new(copy, fn {{x, y}, v} -> {{x - width, y}, v} end)
    right = Map.new(copy, fn {{x, y}, v} -> {{x + width, y}, v} end)

    bottom = Map.new(copy, fn {{x, y}, v} -> {{x, y + height}, v} end)
    bottom_left = Map.new(copy, fn {{x, y}, v} -> {{x - width, y + height}, v} end)
    bottom_right = Map.new(copy, fn {{x, y}, v} -> {{x + width, y + height}, v} end)

    expanded_grid =
      Enum.reduce([top, top_left, top_right, left, right, bottom, bottom_left, bottom_right], grid, &Map.merge/2)

    # Now we will run the simulation and get our different fillings. But how
    # many steps should we run. Well, 1 grid heigt plus the steps to reach the
    # side of the center grid, as we know the solution step reaches the side
    # too.

    sim_steps = n_tiles_side + square_size

    cache_file = "/tmp/fillcache6"

    positions =
      if File.exists?(cache_file) do
        cache_file |> File.read!() |> :erlang.binary_to_term()
      else
        IO.puts("go loop")
        poses = loop([{x_start, y_start}], 1, sim_steps, expanded_grid)
        IO.puts("looped")
        File.write!(cache_file, :erlang.term_to_binary(poses))
        poses
      end

    debug =
      expanded_grid
      |> Map.merge(Map.new(positions, fn xy -> {xy, "O"} end))
      |> Grid.format_map()

    File.write!("/tmp/debug.txt", debug)

    # Alright so to validate that we can just count the coordinates, if we merge
    # the fills between the top and bottom grid, we should have the total number
    # for regular fill.
    # So we should have the same number of in the left and right

    count_topdown = count_slots(positions, Grid.bounds(top)) + count_slots(positions, Grid.bounds(bottom))
    count_leftright = count_slots(positions, Grid.bounds(left)) + count_slots(positions, Grid.bounds(right))
    ^count_topdown = count_leftright

    # This is great but those contains duplicate slots, but with different
    # coordinates. So we translate and merge the two "grid" (we are manipulating
    # lists of coordinates only)
    top_slots_centered =
      positions |> filter_slots(Grid.bounds(top)) |> Enum.map(fn {x, y} -> {x, y + height} end) |> dbg()

    bottom_slots_centered =
      positions |> filter_slots(Grid.bounds(bottom)) |> Enum.map(fn {x, y} -> {x, y - height} end) |> dbg()

    # We will also need left and right to build the 7/8ths tiles

    left_slots_centered =
      positions |> filter_slots(Grid.bounds(left)) |> Enum.map(fn {x, y} -> {x + width, y} end) |> dbg()

    right_slots_centered =
      positions |> filter_slots(Grid.bounds(right)) |> Enum.map(fn {x, y} -> {x - width, y} end) |> dbg()

    # After this translation, top and down cover the whole tile we can merge the two lists and count the unique
    # values
    regular_full_tile = unique_length(top_slots_centered, bottom_slots_centered)

    # A 7/8 tile with the corner cut on top left can be made by merging the tile
    # that points top and the tile that points left, as none of both covers that
    # corner.

    seven_eighteenths_top_left = unique_length(top_slots_centered, left_slots_centered)
    seven_eighteenths_top_right = unique_length(top_slots_centered, right_slots_centered)
    seven_eighteenths_bottom_left = unique_length(bottom_slots_centered, left_slots_centered)
    seven_eighteenths_bottom_right = unique_length(bottom_slots_centered, right_slots_centered)

    # On our 3*3 grid the center grid is filled with the alternate fill.
    alternate_full_tile = count_slots(positions, Grid.bounds(grid))

    # The other alternate fills are the 1/8th tiles on the sides. there are 4 of them

    alternate_eitheenths_count =
      count_slots(positions, Grid.bounds(top_left)) +
        count_slots(positions, Grid.bounds(top_right)) +
        count_slots(positions, Grid.bounds(bottom_left)) +
        count_slots(positions, Grid.bounds(bottom_right))

    # How many of each tiles do we have ?

    # Obviously we have 4 pointy tiles, but 1 of each type

    # Then there are the 1/8th tiles, 4 of them, 1 of each type, for 1 short
    # ray (remember, short ray is the number of grids above the center grid,
    # to the top – a "long ray" would include the center grid).

    n_oneight = short_ray

    # Same for the 7/8th tiles, 4 of them, 1 of each type, for 1 short ray,
    # except the extremities that are the pointy tiles.
    n_seveneight = short_ray - 1

    # How many full regular tiles. They make a pyramid from the middle : n, n-1,
    # n-2, ... 1, but the 1 is not the pointy top, neither the tile below which
    # is an alternate fill. So it is 1+2+3+4+...+(short_ray-1). Here we use
    # short_ray-1 (and not -2) because we want to count the center row.

    # But they also make a pyramid from the middle to the bottom, so we have to
    # calculate that. As we must not count the center row twice, we use short_ray-2

    n_full_regular = sum_to(short_ray - 1) + sum_to(short_ray - 2)

    # For the alternate fills its the same with one more grid range, as they are
    # the inner circle behind the pointy/cut tiles.

    n_full_alternate = sum_to(short_ray) + sum_to(short_ray - 1)

    # Now, adding it all together:

    [
      # The pikes

      length(top_slots_centered),
      length(bottom_slots_centered),
      length(left_slots_centered),
      length(right_slots_centered),

      # The 1/8ths

      alternate_eitheenths_count * n_oneight,

      # The 7/8th

      seven_eighteenths_top_left * n_seveneight,
      seven_eighteenths_top_right * n_seveneight,
      seven_eighteenths_bottom_left * n_seveneight,
      seven_eighteenths_bottom_right * n_seveneight,

      # The full regular tiles

      regular_full_tile * n_full_regular,

      # And the full alternate

      alternate_full_tile * n_full_alternate
    ]
    |> Enum.sum()
  end

  # 1+2+3+4+...+n = n*(n+1)/2
  defp sum_to(n) do
    div(n * (n + 1), 2)
  end

  defp count_slots(xys, {xa, xo, ya, yo}) do
    Enum.count(xys, fn {x, y} -> x in xa..xo && y in ya..yo end)
  end

  defp filter_slots(xys, {xa, xo, ya, yo}) do
    Enum.filter(xys, fn {x, y} -> x in xa..xo && y in ya..yo end)
  end

  defp unique_length(xys_a, xys_b) do
    length(Enum.uniq(xys_a ++ xys_b))
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
