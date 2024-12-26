defmodule AdventOfCode.Solutions.Y22.Day17 do
  alias AoC.Input

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    input |> String.trim() |> String.to_charlist()
  end

  @shape_hbar [{0, 0}, {1, 0}, {2, 0}, {3, 0}]
  @shape_plus [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}]
  @shape_corn [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}]
  @shape_vbar [{0, 0}, {0, 1}, {0, 2}, {0, 3}]
  @shape_squr [{0, 0}, {0, 1}, {1, 0}, {1, 1}]

  def part_one(x_moves) do
    rocks = [@shape_hbar, @shape_plus, @shape_corn, @shape_vbar, @shape_squr]
    rock_tap = tap_of(rocks)
    move_tap = tap_of(x_moves)
    map = %{}
    {_, yh, _, _} = loop_p1(map, -1, move_tap, rock_tap, 0, 2022)
    yh + 1
  end

  defp loop_p1(map, yh, move_tap, rock_tap, max_runs, max_runs) do
    {map, yh, move_tap, rock_tap}
  end

  defp loop_p1(map, yh, move_tap, rock_tap, still_rocks, max_runs) do
    {rock, rock_tap} = pull_tap(rock_tap)
    rock = translate_rock(rock, 2, yh + 4)
    loop_rock(rock, map, yh, move_tap, rock_tap, still_rocks, max_runs)
  end

  defp loop_rock(rock, map, yh, move_tap, rock_tap, still_rocks, max_runs) do
    case move_rock(rock, map, yh, move_tap) do
      {:calcified, map, new_yh, move_tap} ->
        loop_p1(map, new_yh, move_tap, rock_tap, still_rocks + 1, max_runs)

      {:falling, new_rock, move_tap} ->
        loop_rock(new_rock, map, yh, move_tap, rock_tap, still_rocks, max_runs)
    end
  end

  def part_two(x_moves) do
    rocks = [@shape_hbar, @shape_plus, @shape_corn, @shape_vbar, @shape_squr]
    rock_tap = tap_of(rocks)
    move_tap = tap_of(x_moves)
    map = %{}

    {:stable, stable_rocks, stable_yh, move_tap, :repeat, loop_rocks_n, loop_height} =
      search_loop(map, -1, move_tap, rock_tap, 0, %{})

    repeatable_rocks = 1_000_000_000_000 - stable_rocks
    repeat_count = div(repeatable_rocks, loop_rocks_n)

    yh_repeated = stable_yh + repeat_count * loop_height

    case rem(repeatable_rocks, loop_rocks_n) do
      0 ->
        yh_repeated + 1

      n ->
        fake_map = calcify(%{}, translate_rock(Enum.map(0..6, &{&1, -1}), 0, yh_repeated))
        {_, rem_yh, _, _} = loop_p1(fake_map, yh_repeated, move_tap, rock_tap, 0, n)
        rem_yh + 1
    end
  end

  defp search_loop(map, yh, move_tap, rock_tap, still_rocks, prev_remaining) do
    # drop five rocks and check the remaining moves. if they are equal to the
    # previous remaining moves, we have a loop.

    {map, yh, {remain_moves, x_moves} = move_tap, _} = loop_p1(map, yh, move_tap, rock_tap, 0, 5)

    still_rocks = still_rocks + 5

    case Map.get(prev_remaining, remain_moves) do
      nil ->
        prev_remaining = Map.put(prev_remaining, remain_moves, :seen)
        search_loop(map, yh, move_tap, rock_tap, still_rocks, prev_remaining)

      :seen ->
        prev_remaining = Map.put(prev_remaining, remain_moves, {still_rocks, yh})
        search_loop(map, yh, move_tap, rock_tap, still_rocks, prev_remaining)

      {stable_rocks, stable_yh} ->
        true = {remain_moves, x_moves} == move_tap

        {:stable, stable_rocks, stable_yh, move_tap, :repeat, still_rocks - stable_rocks, yh - stable_yh}
    end
  end

  def move_rock(rock, map, yh, move_tap) do
    {mv, move_tap} = pull_tap(move_tap)
    side_rock = blow_rock(rock, mv)

    rock =
      if cross_wall?(side_rock) or touch_any?(side_rock, map) do
        rock
      else
        side_rock
      end

    down_rock = translate_rock(rock, 0, -1)

    if touch_any?(down_rock, map) or cross_floor?(down_rock) do
      new_yh = max(max_y(rock), yh)
      map = calcify(map, rock)
      {:calcified, map, new_yh, move_tap}
    else
      {:falling, down_rock, move_tap}
    end
  end

  defp max_y(list, n \\ 0)

  defp max_y([{_, y} | t], n) when y > n do
    max_y(t, y)
  end

  defp max_y([_ | t], n) do
    max_y(t, n)
  end

  defp max_y([], n) do
    n
  end

  defp calcify(map, rock) do
    adds = Map.new(rock, fn k -> {k, true} end)
    Map.merge(map, adds)
  end

  defp touch_any?([xy | _], map) when is_map_key(map, xy) do
    true
  end

  defp touch_any?([_ | t], map) do
    touch_any?(t, map)
  end

  defp touch_any?([], _) do
    false
  end

  defp cross_wall?([{x, _} | _]) when x < 0 when x > 6 do
    true
  end

  defp cross_wall?([{_, y} | _]) when y < 0 do
    true
  end

  defp cross_wall?([_ | t]) do
    cross_wall?(t)
  end

  defp cross_wall?([]) do
    false
  end

  defp cross_floor?([{_, -1} | _]) do
    true
  end

  defp cross_floor?([_ | t]) do
    cross_floor?(t)
  end

  defp cross_floor?([]) do
    false
  end

  defp tap_of(list) do
    {list, list}
  end

  defp pull_tap({[], list}) do
    pull_tap({list, list})
  end

  defp pull_tap({[h | t], list}) do
    {h, {t, list}}
  end

  defp blow_rock(rock, ?<) do
    translate_rock(rock, -1, 0)
  end

  defp blow_rock(rock, ?>) do
    translate_rock(rock, +1, 0)
  end

  defp translate_rock(rock, add_x, add_y)

  defp translate_rock([{x, y} | t], add_x, add_y) do
    [{x + add_x, y + add_y} | translate_rock(t, add_x, add_y)]
  end

  defp translate_rock([], _, _) do
    []
  end
end
