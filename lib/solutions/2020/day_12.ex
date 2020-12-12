defmodule Aoe.Y20.Day12 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input
    |> Stream.map(&parse_line/1)
  end

  def parse_line(<<char>> <> int) do
    {char, String.to_integer(int)}
  end

  def part_one(problem) do
    problem
    |> Enum.reduce({0, 0, ?E}, &reduce_p1/2)
    |> manhattan()
  end

  defp manhattan({x, y, _}) do
    manhattan({x, y})
  end

  defp manhattan({x, y}) do
    abs(x) + abs(y)
  end

  defp reduce_p1({?N, v}, {x, y, dir}), do: {x, y - v, dir}
  defp reduce_p1({?S, v}, {x, y, dir}), do: {x, y + v, dir}
  defp reduce_p1({?E, v}, {x, y, dir}), do: {x + v, y, dir}
  defp reduce_p1({?W, v}, {x, y, dir}), do: {x - v, y, dir}
  defp reduce_p1({side, amt}, {x, y, dir}) when side in [?L, ?R], do: {x, y, turn(dir, side, amt)}
  defp reduce_p1({?F, v}, {x, y, dir}), do: reduce_p1({dir, v}, {x, y, dir})

  @turn %{
    ?N => %{?L => ?W, ?R => ?E},
    ?S => %{?L => ?E, ?R => ?W},
    ?W => %{?L => ?S, ?R => ?N},
    ?E => %{?L => ?N, ?R => ?S}
  }

  defp turn(dir, _, 0) do
    dir
  end

  defp turn(dir, side, amt) do
    turn(@turn[dir][side], side, amt - 90)
  end

  def part_two(problem) do
    problem
    |> Enum.reduce({{0, 0}, {10, -1}, ?E}, &reduce_p2/2)
    |> elem(0)
    |> manhattan()
  end

  defp reduce_p2({?N, v}, {ship, {wp_x, wp_y}, dir}), do: {ship, {wp_x, wp_y - v}, dir}
  defp reduce_p2({?S, v}, {ship, {wp_x, wp_y}, dir}), do: {ship, {wp_x, wp_y + v}, dir}
  defp reduce_p2({?E, v}, {ship, {wp_x, wp_y}, dir}), do: {ship, {wp_x + v, wp_y}, dir}
  defp reduce_p2({?W, v}, {ship, {wp_x, wp_y}, dir}), do: {ship, {wp_x - v, wp_y}, dir}

  defp reduce_p2({side, 180}, {ship, {wp_x, wp_y}, dir}) when side in [?L, ?R],
    do: {ship, {-wp_x, -wp_y}, dir}

  defp reduce_p2({side, 270}, state) when side in [?L, ?R],
    do: reduce_p2({(side == ?L && ?R) || ?L, 90}, state)

  defp reduce_p2({?L, 90}, {ship, {wp_x, wp_y}, dir}), do: {ship, {wp_y, -wp_x}, dir}
  defp reduce_p2({?R, 90}, {ship, {wp_x, wp_y}, dir}), do: {ship, {-wp_y, wp_x}, dir}

  defp reduce_p2({?F, v}, {{s_x, s_y}, {wp_x, wp_y} = wp, dir}),
    do: {{s_x + v * wp_x, s_y + v * wp_y}, wp, dir}
end
