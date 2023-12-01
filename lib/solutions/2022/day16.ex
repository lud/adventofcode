defmodule Aoe.Y22.Day16 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  defmodule S1 do
    @enforce_keys [:pos, :pressure, :minute, :map, :history]
    defstruct @enforce_keys
  end

  defmodule S2 do
    @enforce_keys [:me_pos, :el_pos, :pressure, :me_minute, :el_minute, :map, :history]
    defstruct @enforce_keys
  end

  @spec read_file(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file(file, _part) do
    # Input.read!(file)
    # Input.stream!(file)
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input(input, _part) do
    input
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  defp parse_line("Valve " <> rest) do
    [valve, "has flow rate=" <> rest] = String.split(rest, " ", parts: 2)

    {rate, valves} =
      case Integer.parse(rest) do
        {rate, "; tunnels lead to valves " <> rest} ->
          valves = String.split(rest, ", ")
          {rate, valves}

        {rate, "; tunnel leads to valve " <> rest} ->
          {rate, [rest]}
      end

    {valve, {rate, valves}}
  end

  def part_one(data) do
    path_map =
      data
      |> Map.new(fn {k, {_rate, valves}} -> {k, valves} end)
      |> compute_paths()

    valve_map =
      data
      |> Enum.filter(fn {_, {rate, _}} -> rate > 0 end)
      |> Map.new(fn {k, {rate, _}} -> {k, {rate, :closed}} end)

    loop_p1("AA", valve_map, path_map, _pressure = 0, _minute = 1)
  end

  defp loop_p1(pos, valve_map, path_map, pressure, minute) do
    init = [%S1{pos: pos, map: valve_map, pressure: pressure, minute: minute, history: []}]
    loop_p1(init, path_map, minute)
  end

  defp loop_p1(states, _, 31) do
    best = Enum.max_by(states, fn %S1{pressure: pressure} -> pressure end)
    %S1{pressure: pressure} = best
    pressure
  end

  defp loop_p1(states, path_map, minute) do
    {advanceables, rest} = Enum.split_with(states, fn %S1{minute: m} -> m <= minute end)

    new_states = Enum.flat_map(advanceables, &find_best_p1(&1, path_map)) ++ rest

    bests =
      Enum.sort_by(new_states, fn %S1{pressure: pressure} -> -pressure end) |> Enum.take(1000)

    # bests = new_states

    loop_p1(bests, path_map, minute + 1)
  end

  defp find_best_p1(s, path_map) do
    %S1{map: valve_map, minute: minute, pos: pos, pressure: pressure, history: history} = s

    valve_map
    |> Enum.filter(fn {_, {_, status}} -> status == :closed end)
    |> case do
      [] ->
        [%S1{s | minute: minute + 1}]

      list ->
        Enum.flat_map(list, fn {k, {rate, :closed}} ->
          {cost_to_move, _} = Map.fetch!(path_map, {pos, k})
          cost_to_open = 1
          new_minute = minute + cost_to_move + cost_to_open

          if new_minute <= 30 do
            # 31 because the minute counter starts at 1, but the action takes place
            # during the minute.
            open_cycles = 31 - cost_to_move - minute - cost_to_open
            add_pressure = open_cycles * rate
            new_pos = k
            new_pressure = pressure + add_pressure
            new_map = Map.update!(valve_map, k, fn {^rate, :closed} -> {rate, :open} end)

            [
              %S1{
                pos: new_pos,
                map: new_map,
                pressure: new_pressure,
                minute: new_minute,
                history: [k | history]
              }
            ]
          else
            []
          end
        end)
        |> case do
          [] -> [%S1{s | minute: minute + 1}]
          l -> l
        end
    end
  end

  defp compute_paths(map) do
    keys = Map.keys(map)

    for from <- keys, to <- keys, from != to, reduce: %{} do
      acc -> Map.put(acc, {from, to}, get_path(map, from, to))
    end
  end

  defp get_path(map, from, to) do
    inits = Enum.map(map[from], &[&1, from])
    get_path_bfs(map, to, inits)
  end

  defp get_path_bfs(map, to, paths) do
    found =
      Enum.find(paths, fn
        [^to | _] -> true
        _ -> false
      end)

    case found do
      nil ->
        new_paths = Enum.flat_map(paths, fn prefix -> get_next_bfs(map, prefix) end)
        get_path_bfs(map, to, new_paths)

      _ ->
        {_cost = length(found) - 1, :lists.reverse(found)}
    end
  end

  defp get_next_bfs(map, [from | prefix]) do
    nexts = Map.fetch!(map, from) |> Enum.filter(&(&1 not in prefix))
    Enum.map(nexts, &[&1, from | prefix])
  end

  def part_two(data) do
    path_map =
      data
      |> Map.new(fn {k, {_rate, valves}} -> {k, valves} end)
      |> compute_paths()

    valve_map =
      data
      |> Enum.filter(fn {_, {rate, _}} -> rate > 0 end)
      |> Map.new(fn {k, {rate, _}} -> {k, {rate, :closed}} end)

    loop_p2("AA", valve_map, path_map, _pressure = 0, _minute = 1)
  end

  defp loop_p2(start_pos, valve_map, path_map, pressure, start_minute) do
    init = [
      %S2{
        me_pos: start_pos,
        el_pos: start_pos,
        map: valve_map,
        pressure: pressure,
        me_minute: start_minute,
        el_minute: start_minute,
        history: []
      }
    ]

    loop_p2(init, path_map, start_minute)
  end

  defp loop_p2(states, _, 27) do
    best = Enum.max_by(states, fn %S2{pressure: pressure} -> pressure end)
    %S2{pressure: pressure} = best
    pressure
  end

  defp loop_p2(states, path_map, minute) do
    {advanceables, rest} =
      Enum.split_with(states, fn %S2{me_minute: me, el_minute: el} ->
        me <= minute or el <= minute
      end)

    new_states = Enum.flat_map(advanceables, &find_best_p2(&1, path_map)) ++ rest

    bests =
      Enum.sort_by(new_states, fn %S2{pressure: pressure} -> -pressure end)
      |> Enum.take(50_000)

    # bests = new_states

    loop_p2(bests, path_map, minute + 1)
  end

  defp find_best_p2(s, path_map) do
    %S2{
      map: valve_map,
      me_minute: me_minute,
      el_minute: el_minute,
      me_pos: me_pos,
      el_pos: el_pos,
      pressure: pressure,
      history: history
    } = s

    for {k1, {rate_1, :closed}} <- valve_map, {k2, {rate_2, :closed}} <- valve_map, k1 != k2 do
      {{k1, rate_1}, {k2, rate_2}}
    end
    |> case do
      [] ->
        bump_minutes(s)

      list ->
        Enum.flat_map(list, fn {{k1, rate_1}, {k2, rate_2}} ->
          {me_changed?, {me_pos, me_minute, valve_map, pressure}} =
            maybe_open_valve(valve_map, path_map, k1, rate_1, me_pos, me_minute, pressure)

          {el_changed?, {el_pos, el_minute, valve_map, pressure}} =
            maybe_open_valve(valve_map, path_map, k2, rate_2, el_pos, el_minute, pressure)

          if me_changed? or el_changed? do
            [
              %S2{
                me_pos: me_pos,
                el_pos: el_pos,
                me_minute: me_minute,
                el_minute: el_minute,
                map: valve_map,
                pressure: pressure,
                history: [{k1, k2} | history]
              }
            ]
          else
            []
          end
        end)
        |> case do
          [] -> bump_minutes(s)
          l -> l
        end
    end
  end

  defp bump_minutes(s) do
    case s do
      %S2{me_minute: me, el_minute: el} when me < 27 and el < 27 ->
        [%S2{s | me_minute: me + 1, el_minute: el + 1}]

      %S2{me_minute: me} when me < 27 ->
        [%S2{s | me_minute: me + 1}]

      %S2{el_minute: el} when el < 27 ->
        [%S2{s | el_minute: el + 1}]
    end
  end

  defp maybe_open_valve(valve_map, path_map, room, rate, pos, minute, pressure) do
    {cost_to_move, _} = Map.fetch!(path_map, {pos, room})
    cost_to_open = 1

    new_minute = minute + cost_to_move + cost_to_open

    if new_minute <= 26 do
      # 27 because the minute counter starts at 1, but the action takes place
      # during the minute.
      open_cycles = 27 - cost_to_move - minute - cost_to_open
      add_pressure = open_cycles * rate
      new_pos = room
      new_pressure = pressure + add_pressure
      new_map = Map.update!(valve_map, room, fn {^rate, :closed} -> {rate, :open} end)
      {true, {new_pos, new_minute, new_map, new_pressure}}
    else
      {false, {pos, minute, valve_map, pressure}}
    end
  end
end
