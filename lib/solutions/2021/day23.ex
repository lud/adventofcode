defmodule AdventOfCode.Y21.Day23.StepCompiler do
  def calc_steps({same_x, same_y}, {same_x, same_y}) do
    []
  end

  def calc_steps({from_x, from_y}, {to_x, _} = to) when from_y == 0 and from_x != to_x do
    # moving the x
    next = {next_coord(from_x, to_x), from_y}
    [next | calc_steps(next, to)]
  end

  def calc_steps({from_x, from_y}, {to_x, _} = to) when from_y > 0 and from_x != to_x do
    # moving the y UP
    next = {from_x, from_y - 1}
    [next | calc_steps(next, to)]
  end

  def calc_steps({from_x, from_y}, {to_x, to_y} = to) when from_x == to_x do
    # moving the y DOWN
    next = {from_x, next_coord(from_y, to_y)}
    [next | calc_steps(next, to)]
  end

  defp next_coord(a, b) when a < b, do: a + 1
  defp next_coord(a, b) when a > b, do: a - 1
end

defmodule AdventOfCode.Y21.Day23 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    "#############\n" <> input = input
    "#...........#\n" <> input = input
    <<"###", t1, "#", t2, "#", t3, "#", t4, "###\n", input::binary>> = input
    <<"  #", l1, "#", l2, "#", l3, "#", l4, _::binary>> = input

    %{
      {2, 1} => c2b(t1),
      {2, 2} => c2b(l1),
      {4, 1} => c2b(t2),
      {4, 2} => c2b(l2),
      {6, 1} => c2b(t3),
      {6, 2} => c2b(l3),
      {8, 1} => c2b(t4),
      {8, 2} => c2b(l4)
    }
  end

  defp c2b(x), do: :erlang.list_to_atom([x])

  def part_all(problem, large?) do
    seen = %{problem => 0}
    reduce([{0, problem}], seen, large?)
  catch
    {:win, nrj} -> nrj
  end

  def part_one(problem) do
    part_all(problem, false)
  end

  def part_two(world) do
    %{
      {2, 2} => l1,
      {4, 2} => l2,
      {6, 2} => l3,
      {8, 2} => l4
    } = world

    world
    |> Map.merge(%{
      {2, 4} => l1,
      {4, 4} => l2,
      {6, 4} => l3,
      {8, 4} => l4,
      #
      {2, 2} => :D,
      {4, 2} => :C,
      {6, 2} => :B,
      {8, 2} => :A,
      {2, 3} => :D,
      {4, 3} => :B,
      {6, 3} => :A,
      {8, 3} => :C
    })
    |> part_all(true)
  end

  defp reduce([best | worlds], seen, large?) do
    {best_nrj, best_world} = best
    if win?(best_world, large?), do: throw({:win, best_nrj})
    # Process.sleep(100)
    nexts = possible_nexts(best, large?)

    {worlds, seen} =
      Enum.reduce(nexts, {worlds, seen}, fn {nrj, world}, {worlds, seen} ->
        case Map.fetch(seen, world) do
          # already seen with lower energy, just skip that one
          {:ok, lower} when lower <= nrj ->
            {worlds, seen}

          # already seen but we found better energy to that state, update the
          # energy in the seen but do not add the state in the list
          {:ok, higher} when higher > nrj ->
            worlds = swap_energy(worlds, world, nrj, higher)
            {worlds, Map.put(seen, world, nrj)}

          # this state is new. maybe it's win. otherwise we add the state in the
          # list and ernegy to the seen
          :error ->
            {insert_world(worlds, nrj, world), Map.put(seen, world, nrj)}
        end
      end)

    reduce(worlds, seen, large?)
  end

  def insert_world([{lower, w} | rest], nrj, world) when nrj > lower,
    do: [{lower, w} | insert_world(rest, nrj, world)]

  def insert_world([{lower, w} | rest], nrj, world) when nrj <= lower,
    do: [{nrj, world}, {lower, w} | rest]

  def insert_world([], nrj, world),
    do: [{nrj, world}]

  defp swap_energy(worlds, world, nrj, higher) do
    worlds = worlds -- [{higher, world}]
    insert_world(worlds, nrj, world)
  end

  def possible_nexts({nrj, world}, large?) do
    # possible destinations for a pod:
    # - if it is in the hallway it can only move to the lowest free place in its
    #   room if there is no other pod species inside
    # - if it is in another room, it can follow the above rule or go in the
    #   hallway

    # movable_rooms = movable_rooms(world, large?)

    Enum.flat_map(world, fn {pos, letter} ->
      destinations = destinations(world, pos, letter, large?)

      Enum.reduce(destinations, [], fn dest, acc ->
        path = get_path(pos, dest)

        if blocked_path?(world, path) do
          acc
        else
          new_nrj = length(path) * cost(letter) + nrj
          next_word = move(world, pos, dest, letter)
          [{new_nrj, next_word} | acc]
        end
      end)
    end)
  end

  defp blocked_path?(world, [p | _]) when is_map_key(world, p), do: true
  defp blocked_path?(world, [_ | path]), do: blocked_path?(world, path)
  defp blocked_path?(_, _), do: false

  defp move(world, pos, dest, letter) do
    world
    |> Map.delete(pos)
    |> Map.put(dest, letter)
  end

  def destinations(world, pos, letter, large?) do
    free_hallways = free_hallways(world)
    yo = yo(large?)

    cond do
      in_hallway?(pos) ->
        next_inroom(world, x_for(letter), yo, letter)

      in_bad_room(pos, letter) ->
        [next_inroom(world, x_for(letter), yo, letter), free_hallways]

      in_place?(world, pos, letter, yo) ->
        []

      # otherwise it may be in place but it is blocking, so it must go in the hallway
      true ->
        free_hallways
    end
    |> :lists.flatten()
  end

  defp free_hallways(world) do
    [
      {0, 0},
      {1, 0},
      {3, 0},
      {5, 0},
      {7, 0},
      {9, 0},
      {10, 0}
    ]
    |> Enum.filter(&(Map.get(world, &1) == nil))
  end

  defp in_bad_room({_x, _y = 0}, _letter), do: false
  defp in_bad_room({x, y}, letter) when y > 0, do: x_for(letter) != x

  defp in_place?(_, {_x, _y = 0}, _letter, _), do: false

  defp in_place?(world, {x, y}, letter, yo) when y > 0 do
    ^x = x_for(letter)

    below_in_place?(world, {x, y + 1}, letter, yo)
  end

  defp below_in_place?(_world, {_x, y}, _letter, yo) when y > yo do
    true
  end

  defp below_in_place?(world, {x, y}, letter, yo) do
    if Map.get(world, {x, y}) == letter do
      below_in_place?(world, {x, y + 1}, letter, yo)
    else
      false
    end
  end

  defp in_hallway?({_x, 0}), do: true
  defp in_hallway?(_false), do: false

  defp next_inroom(world, x, y, letter) when y > 0 do
    case Map.get(world, {x, y}) do
      nil ->
        if room_clean?(world, x, y - 1, letter) do
          [{x, y}]
        else
          []
        end

      ^letter ->
        next_inroom(world, x, y - 1, letter)

      _ ->
        []
    end
  end

  defp next_inroom(_world, _x, 0 = _y, _letter) do
    []
  end

  defp room_clean?(world, x, y, letter) when y > 0 do
    case Map.get(world, {x, y}) do
      nil -> room_clean?(world, x, y - 1, letter)
      _ -> false
    end
  end

  defp room_clean?(_world, _x, 0 = _y, _letter) do
    true
  end

  # defp pos_type({_, 0}, _letter), do: :hallway
  # defp pos_type({x, y}, letter) when y>0 do
  #   case x_for(letter) do
  #     ^x -> :inplace
  #   end
  # end

  # defp get_dest(world, x, _large? = false) do
  #   next_dest(world, Map.get(world, {x, 2}), {x, 2})
  # end

  # defp next_dest(_world, nil, {_, _} = key), do: key

  # defp next_dest(world, _, {x, y}) when y > 1,
  # do: next_dest(world, Map.get(world, {x, y - 1}), {x, y - 1})

  # defp movable_rooms(world, _large? = false) do
  #   %{
  #     :A => Map.get(world, {2, 1}, nil) == nil and Map.get(world, {2, 2}, nil) in [nil, :A],
  #     :B => Map.get(world, {4, 1}, nil) == nil and Map.get(world, {4, 2}, nil) in [nil, :B],
  #     :C => Map.get(world, {6, 1}, nil) == nil and Map.get(world, {6, 2}, nil) in [nil, :C],
  #     :D => Map.get(world, {8, 1}, nil) == nil and Map.get(world, {8, 2}, nil) in [nil, :D]
  #   }
  # end

  defp win?(
         %{
           {2, 1} => :A,
           {2, 2} => :A,
           {4, 1} => :B,
           {4, 2} => :B,
           {6, 1} => :C,
           {6, 2} => :C,
           {8, 1} => :D,
           {8, 2} => :D
         },
         false
       ) do
    true
  end

  defp win?(
         %{
           {2, 1} => :A,
           {2, 2} => :A,
           {2, 3} => :A,
           {2, 4} => :A,
           {4, 1} => :B,
           {4, 2} => :B,
           {4, 3} => :B,
           {4, 4} => :B,
           {6, 1} => :C,
           {6, 2} => :C,
           {6, 3} => :C,
           {6, 4} => :C,
           {8, 1} => :D,
           {8, 2} => :D,
           {8, 3} => :D,
           {8, 4} => :D
         },
         true
       ) do
    true
  end

  defp win?(_, _), do: false

  defp cost(:A), do: 1
  defp cost(:B), do: 10
  defp cost(:C), do: 100
  defp cost(:D), do: 1000
  defp x_for(:A), do: 2
  defp x_for(:B), do: 4
  defp x_for(:C), do: 6
  defp x_for(:D), do: 8
  defp yo(false), do: 2
  defp yo(true), do: 4

  @poses [
    {0, 0},
    {1, 0},
    {3, 0},
    {5, 0},
    {7, 0},
    {9, 0},
    {10, 0},
    {2, 1},
    {2, 2},
    {2, 3},
    {2, 4},
    {4, 1},
    {4, 2},
    {4, 3},
    {4, 4},
    {6, 1},
    {6, 2},
    {6, 3},
    {6, 4},
    {8, 1},
    {8, 2},
    {8, 3},
    {8, 4}
  ]

  for start <- @poses, dest <- @poses, start != dest do
    path = AdventOfCode.Y21.Day23.StepCompiler.calc_steps(start, dest)

    defp get_path(unquote(start), unquote(dest)), do: unquote(path)
  end
end
