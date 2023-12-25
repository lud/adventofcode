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

  # def part_two(problem) do
  #   problem
  # end

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
end
