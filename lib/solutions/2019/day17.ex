defmodule AdventOfCode.Solutions.Y19.Day17 do
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.Grid
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    {grid, _, %{init_pos: _init_pos}} = get_grid(cpu)

    aligment_parameter(grid)
  end

  defp get_grid(cpu) do
    IntCPU.run(cpu, io: IOBuf.new([]))
    |> IntCPU.outputs()
    |> List.to_string()
    |> parse_grid()
  end

  def parse_grid(view) do
    view
    |> String.split("\n")
    |> Grid.parse_lines(fn
      _, ?. -> :ignore
      _, ?# -> {:ok, :scaffold}
      xy, ?^ -> {:ok, :robot, %{init_pos: xy}}
    end)
  end

  def aligment_parameter(grid) do
    # Intersections are scaffolds with another scaffold in all cardinal 4 directions
    intersections =
      Enum.flat_map(grid, fn {xy, _} ->
        if Enum.all?(Grid.cardinal4(xy), &Map.has_key?(grid, &1)) do
          [xy]
        else
          []
        end
      end)

    Enum.sum_by(intersections, fn {x, y} ->
      x * y
    end)
  end

  def part_two(cpu) do
    # To find the patterns we will firt walk along the path. There is a single
    # path from start to end. In intersections we should always continue
    # forward, there is no choice to make
    #
    # We cannot simulate the robot with the CPU as it requires to know the
    # command patterns, so we must do it with the grid.

    {grid, _, %{init_pos: init_pos}} = get_grid(cpu)

    # So we will iterate over the path, registering a full path command
    # robot starts at init_pos, facing north
    _full_path =
      Stream.unfold({init_pos, :n}, fn {pos, dir} ->
        # finding our next tile.
        #
        # a tile can have several neighbours, we will order them by priority and
        # take the first one
        #
        # * highest priority, the tile is in the continuation of the same
        #   direction. This takes priority over turning at an intersection.
        # * second priority, turning left or right
        # * third priority, U-turn. This is not possible for the robot, the only
        #   time we get only a U-turn as possible next tile is when we are on
        #   the last tile, and we can stop the loop.

        pos
        |> Grid.cardinal4()
        |> Enum.filter(&Map.has_key?(grid, &1))
        |> Enum.map(fn new_pos ->
          new_dir = Grid.which_direction(pos, new_pos)
          {new_pos, new_dir, which_rotation(dir, new_dir)}
        end)
        |> Enum.sort_by(fn {_new_pos, new_dir, rotation} ->
          cond do
            new_dir == dir -> 0
            is_binary(rotation) -> 1
            true -> 2
          end
        end)
        |> hd()
        |> case do
          # can move forward, output 1 to move 1 tile
          {new_pos, ^dir, _} ->
            {1, {new_pos, dir}}

          # must rotate, we return the new direction BUT we do NOT return the
          # new position, as we can only move forward
          {_new_pos, new_dir, rotation} when is_binary(rotation) ->
            {rotation, {pos, new_dir}}

          {_, _, :u_turn} ->
            nil
        end
      end)

      # we accumulate the numbers by adding all ones into a single number
      |> Enum.reduce([], fn
        1, [rot | acc] when is_binary(rot) -> [1, rot | acc]
        1, [n | acc] when is_integer(n) -> [n + 1 | acc]
        "L", acc -> ["L" | acc]
        "R", acc -> ["R" | acc]
      end)
      |> :lists.reverse()

      # We convert all integers to string, which will help to find patterns
      # based on the number of characters
      |> Enum.map(&to_string/1)
      |> to_string()

    # IO.puts(full_path)

    # We could do some lengthy algorithms but finding the patterns by hand is easy once you have the full path
    #
    # L4L4L6R10L6L4L4L6R10L6L12L6R10L6R8R10L6R8R10L6L4L4L6R10L6R8R10L6L12L6R10L6R8R10L6L12L6R10L6
    #
    # This gives the following patterns

    # A
    # B
    # C
    # routine
    # enable camera feed y/n

    buf =
      ~c'''
      A,A,B,C,C,A,C,B,C,B
      L,4,L,4,L,6,R,10,L,6
      L,12,L,6,R,10,L,6
      R,8,R,10,L,6
      n
      '''

    # for the camera feed
    # IO.puts("")

    # enable simulation
    1 = IntCPU.deref(cpu, 0)
    cpu = IntCPU.write(cpu, 0, 2)

    cpu =
      IntCPU.run(cpu,
        io: fn
          :init ->
            # If camera feed
            # IO.puts(IO.ANSI.clear())
            # IO.puts(IO.ANSI.cursor(0, 0))

            # we keep the prev output so we can sleep when two successive newlines
            # are output, to get a nice output
            {buf, nil}

          {:input, {[h | t], prev_out}} ->
            {h, {t, prev_out}}

          {:output, char, {buf, _prev_out}} ->
            # if camera feed

            # IO.write(<<char>>)
            # if char == 10 and prev_out == 10 do
            # IO.puts(IO.ANSI.cursor(0, 0))
            # end

            # Even without the feed we need the last character output as it's the
            # solution
            {buf, char}
        end
      )

    %{io: {_, {_buf, last_char}}} = cpu
    last_char
  end

  defp which_rotation(:e, :n), do: "L"
  defp which_rotation(:e, :s), do: "R"
  defp which_rotation(:n, :e), do: "R"
  defp which_rotation(:n, :w), do: "L"
  defp which_rotation(:s, :e), do: "L"
  defp which_rotation(:s, :w), do: "R"
  defp which_rotation(:w, :n), do: "R"
  defp which_rotation(:w, :s), do: "L"
  defp which_rotation(:e, :w), do: :u_turn
  defp which_rotation(:n, :s), do: :u_turn
  defp which_rotation(:s, :n), do: :u_turn
  defp which_rotation(:w, :e), do: :u_turn
  defp which_rotation(same, same), do: :forward
end
