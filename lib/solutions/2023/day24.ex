defmodule AdventOfCode.Y23.Day24 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [coords, velo] = String.split(line, " @ ")
    {ints(coords), ints(velo)}
  end

  defp ints(text) do
    [a, b, c] = String.split(text, ", ")
    {String.to_integer(a), String.to_integer(b), String.to_integer(c)}
  end

  @min 200_000_000_000_000
  @max 400_000_000_000_000

  def part_one([_ | _] = paths) do
    part_one({paths, @min..@max})
  end

  def part_one({paths, rmin..rmax}) do
    paths
    |> Enum.map(&with_equation/1)
    |> count_intersects(rmin..rmax, 0)
  end

  defp count_intersects([h | equations], range, count) do
    range |> IO.inspect(label: ~S/range/)
    count |> IO.inspect(label: ~S/count/)

    count =
      for eq <- equations, reduce: count do
        count ->
          if intersect_in_future_range?(h, eq, range) do
            count + 1
          else
            count
          end
      end

    count_intersects(equations, range, count)
  end

  defp count_intersects([], _, count) do
    count
  end

  defp with_equation({p, v} = stone) do
    # f(x) = ax + b

    {p, v, fx_ab(stone)}
  end

  defp fx_ab({{px, py, pz}, {vx, vy, vz}} = stone) do
    a = vy / vx

    {stone, a}

    a |> IO.inspect(label: ~S/a/)
    # py = a * px + b
    # -py - a*px = b
    b = py - a * px
    b |> IO.inspect(label: ~S/b/)
    {a, b}
  end

  defp intersect_in_future_range?(
         {{px1, py1, pz1}, {vx1, vy1, vz1}, {same_a, b1}},
         {{px2, py2, pz2}, {vx2, vy2, vz2}, {same_a, b2}},
         mini..maxi
       ) do
    false
  end

  defp intersect_in_future_range?(
         {{px1, py1, pz1}, {vx1, vy1, vz1}, {a1, b1}},
         {{px2, py2, pz2}, {vx2, vy2, vz2}, {a2, b2}},
         mini..maxi
       ) do
    # IO.puts("""
    # Hailstone A: #{px1}, #{py1}, #{pz1} @ #{vx1}, #{vy1}, #{vz1}
    # Hailstone B: #{px2}, #{py2}, #{pz2} @ #{vx2}, #{vy2}, #{vz2}
    # """)

    # {px1, py1, pz1} |> IO.inspect(label: ~S/{px1, py1, pz1}/)
    # {px2, py2, pz2} |> IO.inspect(label: ~S/{px2, py2, pz2}/)

    # Intersection point
    x = (b2 - b1) / (a1 - a2)
    y = a1 * x + b1

    # {x, y} |> IO.inspect(label: ~S/cross/)

    # Future?
    future? = ((px1 < x && vx1 >= 0) || (px1 > x && vx1 <= 0)) && ((px2 < x && vx2 >= 0) || (px2 > x && vx2 <= 0))
    # future? |> IO.inspect(label: ~S/future?/)

    in_range? = x >= mini && x <= maxi && y >= mini && y <= maxi

    # if in_range? && future? do
    #   {x, y} |> IO.inspect(label: ~S/cross/)
    # end

    does? = in_range? && future?

    # if does? do
    #   IO.puts("======> +1")
    # end

    does?
  end

  def part_two(stones) do
    # Trying to replicate this :
    # https://community.alteryx.com/t5/General-Discussions/Advent-of-Code-2023-Day-24-BaseA-Style/m-p/1223244
    # byt grouping all stones by velocities so it is easier to find a candidate
    # that will go by each pair in a coordinate system where that common
    # velociti is removed.

    # group the stones by x velocities
    vx_pairs = pairs_by_vx(stones)
    vy_pairs = pairs_by_vy(stones)
    vz_pairs = pairs_by_vz(stones)

    # 0,1,-1,2,-2,3,-3....1000,-1000
    int_stream = Stream.unfold(1, &next_n/1)

    #     # For each X candidate, we will also try to find a Y candidate and a Z.  And
    #     # then for each of those tuples we will try to see, for each store, if that
    #     # stone is hit at T+1 nanosec, if all other stones are hit.
    x_candidates =
      Enum.filter(int_stream, fn cand_vx ->
        Enum.all?(vx_pairs, &hit_on_x?(&1, cand_vx))
      end)

    y_candidates =
      Enum.filter(int_stream, fn cand_vy ->
        Enum.all?(vy_pairs, &hit_on_y?(&1, cand_vy))
      end)

    z_candidates =
      Enum.filter(int_stream, fn cand_vz ->
        Enum.all?(vz_pairs, &hit_on_z?(&1, cand_vz))
      end)

    for x <- x_candidates, y <- y_candidates, z <- z_candidates, reduce: [] do
      acc ->
        IO.puts("try #{inspect({x, y, z})}")

        case sim_hit_all(stones, {x, y, z}) do
          {{t1_pos, vs}, first_hit_ns} ->
            IO.puts("#{inspect(t1_pos)} hits all")
            [move_back({t1_pos, vs}, first_hit_ns) | acc]

          nil ->
            acc
        end
    end
    |> case do
      [{a, b, c}] -> a + b + c
    end
  end

  # To know if the velocity would hit all stones, we consider each stone at
  # T+1ns to be the first hit stone, and we check if from that position all
  # other stones would be hit.
  defp sim_hit_all(stones_t0, {vx, vy, vz} = cand_v) do
    # cand_v |> IO.inspect(label: ~S/cand_v/)

    possible_start_positions = 1..100

    Enum.find_value(possible_start_positions, fn first_hit_on_ns ->
      stones_t1 = Enum.map(stones_t0, &move_stone(&1, first_hit_on_ns))
      init_poses = Enum.map(stones_t1, fn {p_t1, _} -> {p_t1, cand_v} end)

      # We run the simulation, keeping the first hit stone in the list because
      # there could be more at T1
      case Enum.find(init_poses, fn cand ->
             #  cand |> IO.inspect(label: ~S/cand/)
             simulate(stones_t1, cand, first_hit_on_ns)
           end) do
        nil -> nil
        found -> {found, first_hit_on_ns}
      end
    end)
  end

  # When simulating from an initial position we go for max 1000 rounds before
  # bailing
  defp simulate([_ | _] = stones, {p, v}, round) when round > 1000 do
    # IO.puts("bail on round #{round}")
    false
  end

  defp simulate([] = stones, {p, v}, round) do
    true
  end

  defp simulate([_ | _] = stones, {cand_p, cand_v}, round) do
    before = length(stones)

    stones = Enum.filter(stones, fn {p, _} -> p != cand_p end)
    after_ = length(stones)

    if after_ < before do
      IO.puts("hit #{before - after_} stone(s) at round #{round}")
    end

    stones_t_next = Enum.map(stones, &move_stone(&1, 1))
    cand_t_next = move_stone({cand_p, cand_v}, 1)
    simulate(stones_t_next, cand_t_next, round + 1)
  end

  defp move_stone({{px, py, pz}, {vx, vy, vz}}, nanosecs) do
    {{px + vx * nanosecs, py + vy * nanosecs, pz + vz * nanosecs}, {vx, vy, vz}}
  end

  defp move_back({{px, py, pz}, {vx, vy, vz}}, nanosecs) do
    {px - vx * nanosecs, py - vy * nanosecs, pz - vz * nanosecs}
  end

  defp next_n(n) when n > 1000 do
    nil
  end

  defp next_n(n) when n > 0 do
    {n, -n}
  end

  defp next_n(n) when n <= 0 do
    {n, -n + 1}
  end

  # To know if the velocity is ok the first stone should be hit at T0 and the
  # second stone should be hit at TN where N gives a multiple of the stone 2 x
  # velocity and a multiple of the candidate velocity.
  defp hit_on_x?(
         [
           {{px1, py1, pz1}, {vx, vy1, vz1}},
           {{px2, py2, pz2}, {vx, vy2, vz2}}
         ],
         cand_vx
       ) do
    # We put ourselves in the static coordinate system of the second stone, that
    # is, the candidate velocity is vx - rock2_vx do we get the remaining
    # velocity towards rock 2.
    #
    # And we want to know if with this velocity we can hit px2 coming from px1,
    # that is if the distance between px1 and px2 is a multiple of
    # the remaining velocity.
    distance = px1 - px2
    remaining_velocity = cand_vx - vx

    if remaining_velocity == 0 do
      false
    else
      rem(distance, remaining_velocity) == 0
    end
  end

  defp hit_on_y?(
         [
           {{px1, py1, pz1}, {vx1, vy, vz1}},
           {{px2, py2, pz2}, {vx2, vy, vz2}}
         ],
         cand_vy
       ) do
    distance = py1 - py2
    remaining_velocity = cand_vy - vy

    if remaining_velocity == 0 do
      false
    else
      rem(distance, remaining_velocity) == 0
    end
  end

  defp hit_on_z?(
         [
           {{px1, py1, pz1}, {vx1, vy1, vz}},
           {{px2, py2, pz2}, {vx2, vy2, vz}}
         ],
         cand_vz
       ) do
    distance = pz1 - pz2
    remaining_velocity = cand_vz - vz

    if remaining_velocity == 0 do
      false
    else
      rem(distance, remaining_velocity) == 0
    end
  end

  defp pairs_by_vx(stones) do
    group_chunks(stones, fn {{_, _, _}, {vx, _, _}} -> vx end)
  end

  defp pairs_by_vy(stones) do
    group_chunks(stones, fn {{_, _, _}, {_, vy, _}} -> vy end)
  end

  defp pairs_by_vz(stones) do
    group_chunks(stones, fn {{_, _, _}, {_, _, vz}} -> vz end)
  end

  defp group_chunks(stones, grouper) do
    groups = Enum.group_by(stones, grouper)
    Enum.flat_map(groups, fn {_grouper, stones} -> Enum.chunk_every(stones, 2, 1, :discard) end)
  end
end
