defmodule AdventOfCode.Solutions.Y24.Day20 do
  alias AdventOfCode.Grid
  alias AoC.Input

  def parse(input, _part) do
    grid =
      input
      |> Input.stream!(trim: true)
      |> Grid.parse_lines(fn
        _, ?# -> :ignore
        _, ?. -> {:ok, :track}
        xy, ?E -> {:ok, :track, finish: xy}
        xy, ?S -> {:ok, :track, start: xy}
      end)
      |> dbg()
      |> case do
        {grid, bounds, %{start: start, finish: finish}} ->
          dbg({grid, start, finish})
      end
  end

  def part_one({grid, start, finish}, save_at_least \\ 100) do
    # recompute the path as %{pos => {index, next_pos}}
    track = compute_path(grid, start, finish) |> dbg()

    Grid.print(track, fn
      {_index, nil} -> "E"
      {_index, _next} -> "."
      nil -> "#"
    end)

    shortcuts = find_small_shortcuts(track)

    Enum.count(shortcuts, fn {_, _, saved} -> saved >= save_at_least end)
  end

  defp compute_path(grid, start, finish) do
    compute_path(grid, start, _previous = nil, finish, 0, [])
  end

  defp compute_path(grid, finish, prev, finish, index, acc) do
    Map.new([{finish, {index, _next = nil}} | acc])
  end

  defp compute_path(grid, pos, prev, finish, index, acc) do
    [next] = pos |> Grid.cardinal4() |> Enum.filter(&(&1 != prev && Map.has_key?(grid, &1)))
    compute_path(grid, next, pos, finish, index + 1, [{pos, {index, next}} | acc])
  end

  defp find_small_shortcuts(track) do
    Enum.flat_map(track, fn {pos, _} -> find_small_shortcuts(pos, track) end)
  end

  defp find_small_shortcuts(activation_pos, track) do
    # for each cardinal4 neighbor of pos that is not on the track, check if they
    # lead to an other position of the track

    {activation_index, normal_next} = Map.fetch!(track, activation_pos)

    activation_pos
    |> Grid.cardinal4()
    |> Enum.filter(fn wall -> wall != normal_next end)
    |> Enum.flat_map(fn wall ->
      wall
      |> Grid.cardinal4()
      |> Enum.flat_map(fn
        ^activation_pos ->
          []

        next_pos ->
          case Map.fetch(track, next_pos) do
            {:ok, {dest_index, _}} when dest_index > activation_index + 2 ->
              # 2 is the cheat duration
              saved = dest_index - activation_index - 2
              [{activation_pos, next_pos, saved}]

            {:ok, _} ->
              []

            :error ->
              []
          end
      end)
    end)
  end

  def part_two({grid, start, finish}, save_at_least \\ 100) do
    # recompute the path as %{pos => {index, next_pos}}
    track = compute_path(grid, start, finish) |> dbg()

    Grid.print(track, fn
      {_index, nil} -> "E"
      {_index, _next} -> "."
      nil -> "#"
    end)

    shortcuts = find_large_shortcuts(track, save_at_least)

    length(shortcuts) |> dbg()

    IO.puts("done computing shortcuts")
    # Enum.count(shortcuts, fn {_, _, saved} -> saved >= save_at_least end)
    Enum.filter(shortcuts, fn {_, _, saved} -> saved >= save_at_least end)
    |> Enum.frequencies_by(fn {_, _, saved} -> saved end)
    |> Enum.sum_by(fn {_, freq} -> freq end)
  end

  defp find_large_shortcuts(track, save_at_least) do
    Enum.flat_map(track, fn {pos, _} -> find_large_shortcuts(pos, track, save_at_least) end)
  end

  defp find_large_shortcuts(activation_pos, track, save_at_least) do
    {activation_index, _} = Map.fetch!(track, activation_pos)

    IO.write(".")

    Enum.flat_map(track, fn
      {^activation_pos, _} ->
        []

      {next_pos, {dest_index, next_next}} when next_next != next_pos and dest_index > activation_index ->
        dist = manhattan(activation_pos, next_pos)
        saved = dest_index - activation_index - dist

        if saved >= save_at_least do
          [{activation_pos, next_pos, saved}]
        else
          []
        end

      _ ->
        []
    end)
  end

  def manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
