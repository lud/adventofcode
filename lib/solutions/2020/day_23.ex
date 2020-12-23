defmodule Aoe.Y20.Day23 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.read!(file)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input
    |> String.trim()
    |> String.to_integer()
    |> Integer.digits()
  end

  def part_one(cups, moves_count \\ 100) do
    IO.puts("INITIAL: #{inspect(cups)}")
    max_cup = Enum.max(cups)
    [cur | _] = cups
    cmap = init_map(cups, max_cup)
    cmap |> IO.inspect(label: "cmap")

    move(cmap, cur, moves_count, 1, max_cup)
    |> to_list(1)
    |> Enum.drop(1)
    |> Integer.undigits()
    |> to_string
  end

  def part_two(cups) do
    max_cup = Enum.max(cups)
    cups = cups ++ Enum.to_list(10..1_000_000)
    [cur | _] = cups
    cmap = init_map(cups, 1_000_000)
    Map.fetch!(cmap, 1_000_000) |> IO.inspect(label: "Map.fetch!(cmap, 1000000)")

    cmap
    |> to_list(cur, 40)
    |> IO.inspect(label: "initial partial", charlists: :as_lists)

    cmap = move(cmap, cur, 10_000_000, 1, max_cup)
    next_a = cmap[1]
    next_b = cmap[next_a]
    next_a * next_b
  end

  defp move(cmap, cur, max_move, nmove, max_cup) when nmove <= max_move do
    # Process.sleep(1000)

    if rem(nmove, 1000) == 0 do
      IO.puts("move #{nmove}: #{cur}")
    end

    {a, b, c, d} = pick4(cmap, cur)
    dest = find_dest(cur - 1, {a, b, c}, max_cup)
    dest_next = Map.fetch!(cmap, dest)

    # IO.puts("current: #{cur}, move #{a},#{b},#{c} after #{dest}, before #{dest_next}")
    [cur: cur, a: a, b: b, c: c, d: d, dest: dest, dest_next: dest_next]
    |> IO.inspect(label: "binding(partial)")

    cmap =
      cmap
      |> Map.merge(%{dest => a, c => dest_next, cur => d})

    # cmap
    # |> to_list(cur, 40)
    # |> IO.inspect(label: "list", charlists: :as_lists)

    # cmap
    # |> to_list(1_000_000, 40)
    # |> IO.inspect(label: "xend", charlists: :as_lists)

    move(cmap, d, max_move, nmove + 1, max_cup)
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

  defp find_dest(0, _ignored, max_cup) do
    find_dest(max_cup, _ignored, max_cup)
  end

  defp find_dest(cur, {a, b, c}, max_cup) when cur in [a, b, c] do
    find_dest(cur - 1, {a, b, c}, max_cup)
  end

  defp find_dest(cur, _ingored, _max_cup) do
    cur
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
