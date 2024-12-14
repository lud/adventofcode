defmodule AdventOfCode.Solutions.Y24.Day14 do
  alias AoC.Input

  def parse(input, _part) do
    Input.stream!(input, trim: true) |> Enum.map(&parse_ints/1)
  end

  @re_ints ~r/\-?\d+/
  defp parse_ints(line) do
    @re_ints
    |> Regex.scan(line)
    |> :lists.flatten()
    |> Enum.map(&String.to_integer/1)
    |> then(fn [a, b, c, d] -> {{a, b}, {c, d}} end)
  end

  def part_one(robots, room_dimensions \\ {101, 103})

  def part_one(robots, room_dimensions) do
    # when X dimension is 11, then the X range is 0..10, and we want to ignore 5, which is both div(10,2) and div(11,2)
    {w, h} = room_dimensions
    centers = {div(w, 2), div(h, 2)}

    robots
    |> Enum.map(&simulate(&1, room_dimensions, 100))
    |> Enum.group_by(&which_quadrant(&1, centers))
    |> Map.delete(:center)
    |> Enum.product_by(fn {_, poses} -> length(poses) end)
  end

  defp simulate({{px, py}, {vx, vy}}, {mx, my}, seconds) do
    x = px + vx * seconds
    y = py + vy * seconds

    x = Integer.mod(x, mx)
    y = Integer.mod(y, my)

    {x, y}
  end

  def which_quadrant({x, y}, {cx, cy}) when x < cx and y < cy, do: :top_left
  def which_quadrant({x, y}, {cx, cy}) when x < cx and y > cy, do: :bottom_left
  def which_quadrant({x, y}, {cx, cy}) when x > cx and y < cy, do: :top_right
  def which_quadrant({x, y}, {cx, cy}) when x > cx and y > cy, do: :bottom_right
  def which_quadrant(_, _), do: :center

  def part_two(robots, room_dimensions \\ {101, 103}) do
    Enum.reduce_while(1..10000, nil, fn sec, _ ->
      positions = Enum.map(robots, &simulate(&1, room_dimensions, sec))
      map = Map.new(positions, &{&1, true})

      if Enum.all?([{43, 57}, {42, 58}, {43, 58}, {44, 58}], &Map.has_key?(map, &1)) do
        {:halt, sec}
      else
        {:cont, nil}
      end
    end)
  end
end
