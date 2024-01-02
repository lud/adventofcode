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

  defp fx_ab({{px, py, _pz}, {vx, vy, _vz}} = stone) do
    a = vy / vx

    {stone, a}

    # py = a * px + b
    # -py - a*px = b
    b = py - a * px
    {a, b}
  end

  defp intersect_in_future_range?(
         {_, _, {same_a, _}},
         {_, _, {same_a, _}},
         _
       ) do
    false
  end

  defp intersect_in_future_range?(
         {{px1, _, _}, {vx1, _, _}, {a1, b1}},
         {{px2, _, _}, {vx2, _, _}, {a2, b2}},
         mini..maxi
       ) do
    # Intersection point
    x = (b2 - b1) / (a1 - a2)
    y = a1 * x + b1

    # Future?
    future? = ((px1 < x && vx1 >= 0) || (px1 > x && vx1 <= 0)) && ((px2 < x && vx2 >= 0) || (px2 > x && vx2 <= 0))

    in_range? = x >= mini && x <= maxi && y >= mini && y <= maxi

    does? = in_range? && future?

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

    # This does not work for the test input as there are multuple candidates,
    # and I did not implement the check that the found coordinate would work for
    # all stones, as it would be too slow with a real input.

    for x <- x_candidates, y <- y_candidates, z <- z_candidates, reduce: [] do
      acc ->
        case rev_match(stones, {x, y, z}) do
          nil -> acc
          found -> [found | acc]
        end
    end
    |> case do
      # Real input
      [{{a, b, c}, _}] -> a + b + c
      # Sample inputs, should simultate everything and check
      _more -> :todo
    end
  end

  defp rev_match(stones, {_, cand_vy, _} = cand_v) do
    # Find a stone that thas the same Y velocity as our candidate.  We know that
    # it exists with the sample input and my input, so we will discard other
    # possibilities. A more generic solution would try with X and Z as well.
    #
    # This stone and our starting point have the same Y velocity, so they also
    # have the same initial Y, otherwise they would never hit.

    case Enum.filter(stones, fn {{_, _, _}, {_, vy, _}} -> vy == cand_vy end) do
      [] ->
        nil

      [_, _ | _] ->
        nil

      [{{_px, py, _pz}, {_, vy, _}} = found] ->
        # We know py now.
        # Using the first rock, we can derive the rest
        {{_, opy, _}, {_, ovy, _}} = other_rock = Enum.find(stones, fn s -> s != found end)

        hit_time = find_hit_time(opy, ovy, py, vy, 0)
        {or_p_hit, _} = _other_rock_at_hit = move_stone(other_rock, hit_time)

        move_back({or_p_hit, cand_v}, hit_time)
    end
  end

  # This should be the chinese remainder or something like that, but at this
  # point I am too fed up with that math problem to really try so let's just do
  # what I'll call the "brute remainder".
  defp find_hit_time(other_rock_py, other_rock_vy, cand_py, cand_vy, round) do
    diff = other_rock_py - cand_py

    diff = abs(diff)

    if diff == 0 do
      round
    else
      cond do
        diff > 10_000_000_000 ->
          mult = 1_000_000

          find_hit_time(
            other_rock_py + other_rock_vy * mult,
            other_rock_vy,
            cand_py + cand_vy * mult,
            cand_vy,
            round + mult
          )

        diff > 1_000_000_000 ->
          mult = 100_000

          find_hit_time(
            other_rock_py + other_rock_vy * mult,
            other_rock_vy,
            cand_py + cand_vy * mult,
            cand_vy,
            round + mult
          )

        diff > 1_000_000 ->
          mult = 1000

          find_hit_time(
            other_rock_py + other_rock_vy * mult,
            other_rock_vy,
            cand_py + cand_vy * mult,
            cand_vy,
            round + mult
          )

        diff > 100_000 ->
          mult = 100

          find_hit_time(
            other_rock_py + other_rock_vy * mult,
            other_rock_vy,
            cand_py + cand_vy * mult,
            cand_vy,
            round + mult
          )

        true ->
          mult = 1

          find_hit_time(
            other_rock_py + other_rock_vy * mult,
            other_rock_vy,
            cand_py + cand_vy * mult,
            cand_vy,
            round + mult
          )
      end
    end
  end

  defp move_stone({{px, py, pz}, {vx, vy, vz}}, nanosecs) do
    {{px + vx * nanosecs, py + vy * nanosecs, pz + vz * nanosecs}, {vx, vy, vz}}
  end

  defp move_back({{px, py, pz}, {vx, vy, vz}}, nanosecs) do
    {{px - vx * nanosecs, py - vy * nanosecs, pz - vz * nanosecs}, {vx, vy, vz}}
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
           {{px1, _, _}, {vx, _, _}},
           {{px2, _, _}, {vx, _, _}}
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
           {{_, py1, _}, {_, vy, _}},
           {{_, py2, _}, {_, vy, _}}
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
           {{_, _, pz1}, {_, _, vz}},
           {{_, _, pz2}, {_, _, vz}}
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
