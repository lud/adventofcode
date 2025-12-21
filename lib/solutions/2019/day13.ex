defmodule AdventOfCode.Solutions.Y19.Day13 do
  alias AdventOfCode.Grid
  alias AdventOfCode.IntCPU
  alias AdventOfCode.IntCPU.IOBuf

  def parse(input, _part) do
    IntCPU.from_input(input)
  end

  def part_one(cpu) do
    cpu
    |> IntCPU.run(io: IOBuf.new([]))
    |> IntCPU.outputs()
    |> Enum.chunk_every(3)
    |> Enum.reduce(%{}, fn [x, y, tile], grid ->
      Map.put(grid, {x, y}, tile)
    end)
    |> Enum.count(fn {_, t} -> t == 2 end)
  end

  require Record
  Record.defrecordp(:state, grid: %{}, ball_x: nil, pad_x: nil, score: 0, out_buf: [])

  @empty 0
  @wall 1
  @block 2
  @pad 3
  @ball 4

  @joystick_neutral 0
  @joystick_left -1
  @joystick_right 1

  def part_two(cpu) do
    io = fn
      :init ->
        state()

      {:output, new_score, state(out_buf: [0, -1]) = state} ->
        state(state, score: new_score, out_buf: [])

      {:output, tile_id, state(out_buf: [y, x]) = state} ->
        state(grid: grid) = state
        grid = Map.put(grid, {x, y}, tile_id)

        # print_grid(grid, state(state, :score))

        state =
          case tile_id do
            @pad -> state(state, pad_x: x)
            @ball -> state(state, ball_x: x)
            _ -> state
          end

        state(state, grid: grid, out_buf: [])

      {:output, x_or_y, state(out_buf: out_buf) = state} ->
        state(state, out_buf: [x_or_y | out_buf])

      {:input, state(ball_x: ball_x, pad_x: pad_x) = state} ->
        joystick_input =
          cond do
            ball_x == pad_x -> @joystick_neutral
            ball_x < pad_x -> @joystick_left
            ball_x > pad_x -> @joystick_right
          end

        {joystick_input, state}
    end

    cpu
    |> IntCPU.write(0, 2)
    |> IntCPU.run(io: io)
    |> then(fn %{io: {_, state(score: score)}} -> score end)
  end

  def print_grid(grid, score) do
    IO.puts(IO.ANSI.clear())
    IO.puts(IO.ANSI.cursor(0, 0))

    IO.puts("""
    ------
    score: #{score}
    """)

    Grid.print(grid, fn
      @wall -> "|"
      @block -> "#"
      @pad -> "_"
      @ball -> "O"
      @empty -> " "
      nil -> " "
    end)
  end
end
