defmodule AdventOfCode.Y20.Day23 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    input
    |> String.trim()
    |> String.to_integer()
    |> Integer.digits()
  end

  def part_one(cups, moves_count \\ 100) do
    max_cup = Enum.max(cups)
    [cur | _] = cups
    cmap = init_map(cups, max_cup)

    move(cmap, cur, moves_count, 1, max_cup)
    |> to_list(1)
    |> Enum.drop(1)
    |> Integer.undigits()
    |> to_string
  end

  def part_two(cups) do
    max_cup = 1_000_000
    cups = cups ++ Enum.to_list(10..max_cup)
    [cur | _] = cups
    cmap = init_map(cups, max_cup)

    cmap = move(cmap, cur, 10_000_000, 1, max_cup)
    next_a = cmap[1]
    next_b = cmap[next_a]
    next_a * next_b
  end

  defp move(cmap, cur, max_move, nmove, max_cup) when nmove <= max_move do
    if rem(nmove, 100_000) == 0 do
      IO.puts("move #{nmove}: #{cur}")
    end

    {a, b, c, d} = pick4(cmap, cur)
    dest = find_dest(cur - 1, {a, b, c}, max_cup)
    dest_next = Map.fetch!(cmap, dest)

    cmap
    |> Map.merge(%{dest => a, c => dest_next, cur => d})
    |> move(d, max_move, nmove + 1, max_cup)
  end

  defp move(cmap, _cur, _max_move, _nmove, _max_cup) do
    cmap
  end

  defp _to_list(_, _, _, 0) do
    []
  end

  defp _to_list(_, cur, cur, _) do
    []
  end

  defp _to_list(cmap, cur, stop, length) when length > 0 do
    [cur | _to_list(cmap, cmap[cur], stop, length - 1)]
  end

  defp to_list(cmap, cur, length \\ 1_000_000) do
    [cur | _to_list(cmap, cmap[cur], cur, length - 1)]
  end

  defp pick4(cmap, cur) do
    a = Map.fetch!(cmap, cur)
    b = Map.fetch!(cmap, a)
    c = Map.fetch!(cmap, b)
    d = Map.fetch!(cmap, c)
    {a, b, c, d}
  end

  defp find_dest(0, ignored, max_cup) do
    find_dest(max_cup, ignored, max_cup)
  end

  defp find_dest(candidate, {a, b, c}, max_cup) when candidate in [a, b, c] do
    find_dest(candidate - 1, {a, b, c}, max_cup)
  end

  defp find_dest(candidate, _ingored, _max_cup) do
    candidate
  end

  # define a map where the cups are the keys, and the values are tne next cup
  defp init_map([first | _] = cups, max_cup) do
    # [second | _] = cups
    [last | cups] = :lists.reverse(cups)
    init_map(cups, last, %{last => first, :max => max_cup})
  end

  defp init_map([cur | cups], next, map) do
    map = Map.put(map, cur, next)
    init_map(cups, cur, map)
  end

  defp init_map([], _later, map) do
    map
  end
end
