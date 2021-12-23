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
      grid: %{
        {2, 1} => c2b(t1),
        {2, 2} => c2b(l1),
        {4, 1} => c2b(t2),
        {4, 2} => c2b(l2),
        {6, 1} => c2b(t3),
        {6, 2} => c2b(l3),
        {8, 1} => c2b(t4),
        {8, 2} => c2b(l4)
      },
      nrj: 0,
      large: false
    }
  end

  defp c2b(x), do: :erlang.list_to_binary([x])

  def part_one(world) do
    worlds = [world]
    reduce(worlds)
  end

  defp reduce([best | rest] = all) do
    # IO.puts("BEST")
    # print_world(best)
    best.nrj |> IO.inspect(label: "best.nrj")

    if is_win(best) do
      best.nrj
    else
      nexts = possible_nexts(best)
      # IO.puts("NEXTS")
      # nexts |> Enum.map(&print_world/1)
      # IO.puts("#{length(nexts)} possible nexts")
      news = Enum.reduce(nexts, rest, &insert_world/2)

      # Process.sleep(500)
      reduce(news)
    end
  end

  defp destinations_from({_, 0}, letter, _large = false) do
    [
      {x_for(letter), 2},
      {x_for(letter), 1}
    ]
  end

  defp destinations_from({x, y}, letter, _large = false) when y > 0 do
    dest_x = x_for(letter)

    if dest_x != x do
      cond do
        y == 1 -> [{x_for(letter), 2}]
        y == 2 -> []
      end
    else
      []
    end ++
      [
        {0, 0},
        {1, 0},
        {3, 0},
        {5, 0},
        {7, 0},
        {9, 0},
        {10, 0}
      ]
  end

  defp possible_nexts(%{nrj: nrj, grid: grid, large: false = large?} = w) do
    poses = Map.keys(grid)

    # grid |> IO.inspect(label: "grid")

    for {pos, letter} <- grid, dest <- destinations_from(pos, letter, large?), dest != pos do
      # pos |> IO.inspect(label: "pos")
      # letter |> IO.inspect(label: "letter")
      # dest |> IO.inspect(label: "dest")
      true = pos != dest
      steps = calc_steps(pos, dest)
      [_ | _] = steps
      # steps |> IO.inspect(label: "steps")

      # IO.puts("move #{letter} from #{inspect(pos)} to #{inspect(dest)}, for $#{energy}")

      if can_move?(steps, poses, letter, dest, grid, large?) do
        # IO.puts(" => valid")
        move(w, pos, dest, steps)
      else
        # IO.puts("=> invalid")
        :invalid
      end
    end
    |> filter_invalid()
  end

  def move(%{grid: grid, nrj: nrj} = world, pos, dest, steps) do
    letter = Map.fetch!(grid, pos)
    energy = cost(letter) * length(steps)

    grid =
      grid
      |> Map.delete(pos)
      |> Map.put(dest, letter)

    # energy |> IO.inspect(label: "add energy")

    %{world | grid: grid, nrj: nrj + energy}
  end

  defp filter_invalid([:invalid | rest]), do: filter_invalid(rest)
  defp filter_invalid([w | rest]), do: [w | filter_invalid(rest)]
  defp filter_invalid([]), do: []

  defp filter_moves(moves, poses) do
    Enum.filter(moves, &valid_move?(&1, poses))
  end

  defp can_move?(move, poses, letter, {_, y} = dest, grid, large?) do
    # move |> IO.inspect(label: "valid?")

    if valid_move?(move, poses) do
      cond do
        y > 0 and is_stranger(Map.get(grid, {x_for(letter), 1}), letter) -> false
        y > 0 and is_stranger(Map.get(grid, {x_for(letter), 2}), letter) -> false
        y > 0 and is_stranger(Map.get(grid, {x_for(letter), 3}), letter) -> false
        y > 0 and is_stranger(Map.get(grid, {x_for(letter), 4}), letter) -> false
        y == 1 and Map.get(grid, {x_for(letter), y + 1}) == nil -> false
        true -> true
      end
    else
      false
    end
  end

  defp is_stranger(nil, _), do: false
  defp is_stranger(same, same), do: false
  defp is_stranger(".", _), do: false
  defp is_stranger(_, _), do: true

  defp valid_move?(move, [taken | poses]) do
    if taken in move do
      false
    else
      valid_move?(move, poses)
    end
  end

  defp valid_move?(move, []), do: true

  defp is_win(%{
         :large => false,
         grid: %{
           {2, 1} => "A",
           {2, 2} => "A",
           {4, 1} => "B",
           {4, 2} => "B",
           {6, 1} => "C",
           {6, 2} => "C",
           {8, 1} => "D",
           {8, 2} => "D"
         }
       }) do
    true
  end

  defp is_win(_), do: false

  defp insert_world(%{grid: same, nrj: jw} = w, [%{grid: same, nrj: jc} = candidate | rest]) do
    if jw <= jc do
      [w | rest]
    else
      insert_world(w, rest)
    end
  end

  defp insert_world(%{nrj: left} = w, [%{nrj: right} = candidate | rest]) when left >= right,
    do: [candidate | insert_world(w, rest)]

  defp insert_world(%{nrj: left} = w, [%{nrj: right} = candidate | rest]) when left < right,
    do: [w, candidate | rest]

  defp insert_world(w, []), do: [w]

  # defp move(world, from, {to_x, to_y} = to) do
  #   pod = Map.fetch!(world, from)
  #   check_move(pod, to_x, to_y)
  #   steps = calc_steps(from, to)

  #   Enum.each(steps, fn step ->
  #     cell = Map.get(world, step, ".")

  #     if cell != "." do
  #       raise "cannot move by #{inspect(step)}: #{inspect(cell)} inside"
  #     end
  #   end)

  #   energy = cost(pod) * length(steps)
  #   IO.puts("move #{pod} from #{inspect(from)} to #{inspect(to)}, for $#{energy}")

  #   world
  #   |> Map.delete(from)
  #   |> Map.put(to, pod)
  #   |> Map.update!(:nrj, &(&1 + energy))
  # end

  defp cost("A"), do: 1
  defp cost("B"), do: 10
  defp cost("C"), do: 100
  defp cost("D"), do: 1000
  defp x_for("A"), do: 2
  defp x_for("B"), do: 4
  defp x_for("C"), do: 6
  defp x_for("D"), do: 8

  # def calc_steps({same_x, same_y}, {same_x, same_y}) do
  #   []
  # end

  # def calc_steps({from_x, from_y}, {to_x, to_y}) when from_y == 0 do
  #   # start by moving x
  #   [_ | steps] = for x <- from_x..to_x, do: {x, from_y}
  #   steps ++ calc_steps({to_x, from_y}, {to_x, to_y})
  # end

  # def calc_steps({from_x, from_y}, {to_x, to_y}) when from_y > 0 do
  #   # start by moving y
  #   [_ | steps] = for y <- from_y..to_y, do: {from_x, y}
  #   steps ++ calc_steps({from_x, to_y}, {to_x, to_y})
  # end

  def calc_steps({same_x, same_y}, {same_x, same_y}) do
    []
  end

  def calc_steps({from_x, from_y}, {to_x, to_y} = to) when from_y == 0 and from_x != to_x do
    # moving the x
    next = {next_coord(from_x, to_x), from_y}
    # next |> IO.inspect(label: "next")
    [next | calc_steps(next, to)]
  end

  def calc_steps({from_x, from_y}, {to_x, to_y} = to) when from_y > 0 and from_x != to_x do
    # moving the y UP
    next = {from_x, from_y - 1}
    # next |> IO.inspect(label: "next")
    [next | calc_steps(next, to)]
  end

  def calc_steps({from_x, from_y}, {to_x, to_y} = to) when from_x == to_x do
    # moving the y DOWN
    next = {from_x, next_coord(from_y, to_y)}
    # next |> IO.inspect(label: "next")
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

  def print_world(w) do
    w |> format_world() |> IO.puts()
    w
  end

  defp format_world(%{large: false, grid: grid} = w) do
    [
      "#############\n",
      "#",
      for x <- 0..10 do
        gc(grid, x, 0)
      end,
      "#\n",
      "###",
      gc(grid, 2, 1),
      "#",
      gc(grid, 4, 1),
      "#",
      gc(grid, 6, 1),
      "#",
      gc(grid, 8, 1),
      "###\n",
      "  #",
      gc(grid, 2, 2),
      "#",
      gc(grid, 4, 2),
      "#",
      gc(grid, 6, 2),
      "#",
      gc(grid, 8, 2),
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
