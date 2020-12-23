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

  defp move(cmap, cur, max_move, nmove, max_cup) when nmove <= max_move do
    IO.puts("move #{nmove}: #{cur}")
    {a, b, c, d} = pick4(cmap, cur)
    dest = find_dest(cur - 1, {a, b, c}, max_cup)
    dest_next = Map.fetch!(cmap, dest)

    # cmap
    # |> to_list(cur)
    # |> IO.inspect(label: "list")

    cmap
    |> Map.merge(%{dest => a, c => dest_next, cur => d})
    |> move(d, max_move, nmove + 1, max_cup)
  end

  defp move(cmap, _cur, _max_move, _nmove, _max_cup) do
    cmap
  end

  defp to_list(cmap, cur, cur) do
    []
  end

  defp to_list(cmap, cur, stop) do
    IO.puts("picked #{cur} != #{stop}")
    Process.sleep(10)
    [cur | to_list(cmap, cmap[cur], stop)]
  end

  defp to_list(cmap, cur) do
    cmap |> IO.inspect(label: "cmap")
    [cur | to_list(cmap, cmap[cur], cur)]
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

  def part_two(problem) do
    problem
  end
end
