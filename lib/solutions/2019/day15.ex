defmodule AdventOfCode.Solutions.Y19.Day15 do
  alias AdventOfCode.IntCPU.IOBuf
  alias AdventOfCode.Grid
  alias AdventOfCode.IntCPU

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  @north 1
  @south 2
  @west 3
  @east 4

  # droid does not move when it hits a wal
  @status_wall 0
  # moved 1 tile in the correct direction
  @status_moved 1
  # moved 1 tile in the correct direction and found oxygen tank
  @status_moved_found 2

  require Record
  Record.defrecordp(:state, grid: %{}, pos: {0, 0}, next_pos: nil)

  def part_one(cpu) do
    # Grid values will be {tile, parent} where parent is the xy for the tile we
    # went from.
    #
    # It is a maze without loops so we cannot find shortcuts, the parent is
    # always the best parent
    init_grid = %{{0, 0} => {:free, :root}}

    io = fn
      :init ->
        state(grid: init_grid)

      {:input, state} ->
        state(pos: pos, grid: grid) = state

        # when asked for input we must explore tiles around.
        # we look for the first tile that we do not know
        next_pos =
          pos
          |> Grid.cardinal4()
          |> Enum.find(&(not Map.has_key?(grid, &1)))
          |> case do
            nil ->
              # backtrack to parent of current pos
              case Map.fetch!(grid, pos) do
                {:free, :root} -> raise "back to zero not found oxygen"
                {:free, parent} -> parent
              end

            next_pos ->
              next_pos
          end

        move_command = translate_direction(Grid.which_direction(pos, next_pos))

        true = is_tuple(next_pos)
        {move_command, state(state, next_pos: next_pos)}

      {:output, @status_wall, state} ->
        state(pos: pos, next_pos: next_pos, grid: grid) = state
        grid = Map.put_new(grid, next_pos, {:wall, _parent = pos})
        state = state(state, grid: grid, next_pos: nil)

        #  print_state(state)
        state

      {:output, @status_moved, state} ->
        state(pos: pos, next_pos: next_pos, grid: grid) = state
        grid = Map.put_new(grid, next_pos, {:free, _parent = pos})
        # we move to the next pos
        state = state(state, grid: grid, pos: next_pos, next_pos: nil)
        #  print_state(state)
        state

      {:output, @status_moved_found, state} ->
        state(pos: pos, next_pos: next_pos, grid: grid) = state
        grid = Map.put_new(grid, next_pos, {:oxygen, _parent = pos})
        # we move to the next pos
        state = state(state, grid: grid, pos: next_pos, next_pos: nil)
        throw({:found, state})
    end

    IntCPU.run(cpu, io: io)
  catch
    {:found, state} -> count_backtrack(state)
  end

  defp count_backtrack(state) do
    state(pos: pos, grid: grid) = state
    count_backtrack(grid, pos, 0)
  end

  defp count_backtrack(grid, pos, count) do
    case Map.fetch!(grid, pos) do
      {_, :root} -> count
      {_, new_pos} -> count_backtrack(grid, new_pos, count + 1)
    end
  end

  defp translate_direction(dir) do
    case dir do
      :n -> @north
      :s -> @south
      :w -> @west
      :e -> @east
    end
  end

  def print_state(state) do
    IO.puts(IO.ANSI.clear())
    IO.puts(IO.ANSI.cursor(0, 0))

    state(grid: grid, pos: pos) = state

    Grid.print(Map.put(grid, pos, :robot), fn
      :robot -> "Ö"
      nil -> " "
      {:wall, _} -> "#"
      {:free, _} -> "."
    end)

    Process.sleep(10)

    state
  end

  # def part_two(cpu) do
  #   cpu
  # end
end
