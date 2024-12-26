defmodule AdventOfCode.Solutions.Y15.Day02 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [l, w, h] = String.split(line, "x")

    {String.to_integer(l), String.to_integer(w), String.to_integer(h)}
  end

  def part_one(problem) do
    problem
    |> Enum.map(&compute_surface/1)
    |> Enum.sum()
  end

  defp compute_surface({l, w, h}) do
    2 * l * w + 2 * w * h + 2 * h * l + min(l * w, min(w * h, h * l))
  end

  def part_two(problem) do
    problem
    |> Enum.map(&compute_ribbon/1)
    |> Enum.sum()
  end

  defp compute_ribbon({l, w, h}) do
    [a, b, _c] = Enum.sort([l, w, h])
    2 * a + 2 * b + l * w * h
  end
end
