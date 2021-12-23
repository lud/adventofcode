defmodule Aoe.Y21.Day23 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    "#############\n" <> input = input
    "#...........#\n" <> input = input
    <<"###", t1, "#", t2, "#", t3, "#", t4, "###\n", input::binary>> = input
    <<"  #", l1, "#", l2, "#", l3, "#", l4, _::binary>> = input

    world = %{
      {2, 1} => c2b(t1),
      {2, 2} => c2b(l1),
      {4, 1} => c2b(t2),
      {4, 2} => c2b(l2),
      {6, 1} => c2b(t3),
      {6, 2} => c2b(l3),
      {8, 1} => c2b(t4),
      {8, 2} => c2b(l4),
      :nrj => 0
    }
  end

  defp c2b(x), do: :erlang.list_to_binary([x])

  def part_one(world) do
    world
    |> print_world()
    |> print_move({4, 1}, {0, 0})
    |> print_move({4, 2}, {1, 0})
    |> print_move({6, 1}, {7, 0})
    |> print_move({6, 2}, {4, 2})
    |> print_move({7, 0}, {6, 2})
    |> print_move({8, 1}, {6, 1})
    |> print_move({8, 2}, {4, 1})
    |> print_move({2, 1}, {8, 2})
    |> print_move({2, 2}, {8, 1})
    |> print_move({1, 0}, {2, 2})
    |> print_move({0, 0}, {2, 1})

    # |> print_move({8, 1}, {10, 0})
    # |> print_move({8, 2}, {9, 0})
    # |> print_move({2, 1}, {8, 2})
    # |> print_move({2, 2}, {8, 1})
    # |> print_move({4, 1}, {2, 2})
    # |> print_move({4, 2}, {2, 1})
    # |> print_move({9, 0}, {4, 2})
    # |> print_move({6, 1}, {7, 0})
    # |> print_move({6, 2}, {4, 1})
    # |> print_move({7, 0}, {6, 2})
    # |> print_move({10, 0}, {6, 1})
  end

  defp print_move(world, from, to) do
    world = move(world, from, to)
    print_world(world)
  end

  defp move(world, from, {to_x, to_y} = to) do
    pod = Map.fetch!(world, from)
    check_move(pod, to_x, to_y)
    steps = calc_steps(from, to)

    Enum.each(steps, fn step ->
      cell = Map.get(world, step, ".")

      if cell != "." do
        raise "cannot move by #{inspect(step)}: #{inspect(cell)} inside"
      end
    end)

    energy = cost(pod) * length(steps)
    IO.puts("move #{pod} from #{inspect(from)} to #{inspect(to)}, for $#{energy}")

    world
    |> Map.delete(from)
    |> Map.put(to, pod)
    |> Map.update!(:nrj, &(&1 + energy))
  end

  defp cost("A"), do: 1
  defp cost("B"), do: 10
  defp cost("C"), do: 100
  defp cost("D"), do: 1000

  # defp calc_steps({same_x, same_y}, {same_x, same_y}) do
  #   []
  # end

  # defp calc_steps({from_x, from_y}, {to_x, to_y}) when from_y == 0 do
  #   # start by moving x
  #   [_ | steps] = for x <- from_x..to_x, do: {x, from_y}
  #   steps ++ calc_steps({to_x, from_y}, {to_x, to_y})
  # end

  # defp calc_steps({from_x, from_y}, {to_x, to_y}) when from_y > 0 do
  #   # start by moving y
  #   [_ | steps] = for y <- from_y..to_y, do: {from_x, y}
  #   steps ++ calc_steps({from_x, to_y}, {to_x, to_y})
  # end

  defp calc_steps({same_x, same_y}, {same_x, same_y}) do
    []
  end

  defp calc_steps({from_x, from_y}, {to_x, to_y} = to) when from_y == 0 and from_x != to_x do
    # moving the x
    next = {next_coord(from_x, to_x), from_y}
    [next | calc_steps(next, to)]
  end

  defp calc_steps({from_x, from_y}, {to_x, to_y} = to) when from_y > 0 and from_x != to_x do
    # moving the y UP
    next = {from_x, from_y - 1}
    [next | calc_steps(next, to)]
  end

  defp calc_steps({from_x, from_y}, {to_x, to_y} = to) when from_x == to_x do
    # moving the y DOWN
    next = {from_x, from_y + 1}
    [next | calc_steps(next, to)]
  end

  defp next_coord(a, b) when a < b, do: a + 1
  defp next_coord(a, b) when a > b, do: a - 1

  defp check_move(pod, to_x, 0) when to_x in [2, 4, 6, 8] do
    raise "Bad move: cannot stop outside room"
  end

  defp check_move(pod, to_x, to_y) do
    if to_y > 0 do
      case {pod, to_x} do
        {"A", 2} -> :ok
        {"B", 4} -> :ok
        {"C", 6} -> :ok
        {"D", 8} -> :ok
        other -> raise "Bad move: cannot enter other room"
      end
    else
      0 = to_y
      :ok
    end
  end

  defp print_world(w) do
    w |> format_world() |> IO.puts()
    w
  end

  defp format_world(w) do
    [
      "#############\n",
      "#",
      for x <- 0..10 do
        gc(w, x, 0)
      end,
      "#\n",
      "###",
      gc(w, 2, 1),
      "#",
      gc(w, 4, 1),
      "#",
      gc(w, 6, 1),
      "#",
      gc(w, 8, 1),
      "###\n",
      "  #",
      gc(w, 2, 2),
      "#",
      gc(w, 4, 2),
      "#",
      gc(w, 6, 2),
      "#",
      gc(w, 8, 2),
      "#\n",
      "  #########\n",
      "  energy: #{w.nrj}"
    ]
  end

  defp gc(w, x, y) do
    Map.get(w, {x, y}, ".")
  end

  def part_two(problem) do
    problem
  end
end
