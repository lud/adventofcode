defmodule AdventOfCode.Y15.Day6 do
  alias AoC.Input, warn: false
  alias AoC.Rect

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    {op, rect_str} =
      case line do
        "turn on " <> rest -> {:on, rest}
        "turn off " <> rest -> {:off, rest}
        "toggle " <> rest -> {:toggle, rest}
      end

    {op, parse_rect(rect_str)}
  end

  defp parse_rect(str) do
    [topleft, bottom_right] = String.split(str, " through ")
    topleft = parse_corner(topleft)
    bottom_right = parse_corner(bottom_right)
    Rect.from_points(topleft, bottom_right, :off)
  end

  defp parse_corner(str) do
    [x, y] = String.split(str, ",")
    {String.to_integer(x), String.to_integer(y)}
  end

  def part_one(problem) do
    lights = [Rect.from_ranges(0..999, 0..999, :off)]
    lights = Enum.reduce(problem, lights, &reduce_ops/2)
    lights |> Enum.filter(fn lightrec -> lightrec.value == :on end) |> Enum.map(&Rect.area/1) |> Enum.sum()
  end

  defp reduce_ops({op, rect}, lights) do
    {covered, remains} = split_lights(lights, rect, [], [])
    covered = Enum.map(covered, fn lightrec -> apply_op(lightrec, op) end)
    covered ++ remains
  end

  defp split_lights([h | t], rect, covered, remains) do
    {cov, rem} = Rect.split(h, rect)
    split_lights(t, rect, cov ++ covered, rem ++ remains)
  end

  defp split_lights([], _rect, covered, remains) do
    {covered, remains}
  end

  defp apply_op(lightrec, :on) do
    %{lightrec | value: :on}
  end

  defp apply_op(lightrec, :off) do
    %{lightrec | value: :off}
  end

  defp apply_op(%{value: :on} = lightrec, :toggle) do
    %{lightrec | value: :off}
  end

  defp apply_op(%{value: :off} = lightrec, :toggle) do
    %{lightrec | value: :on}
  end

  # def part_two(problem) do
  #   problem
  # end
end
