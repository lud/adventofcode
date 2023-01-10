defmodule Aoe.Y16.Day18 do
  alias Aoe.Grid
  alias Aoe.Input, warn: false

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.stream_file_lines(file)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    Grid.parse_stream(input, &parse_char/1)
  end

  defp parse_char("#"), do: {:ok, :wall}
  defp parse_char("."), do: {:ok, :floor}
  defp parse_char("@"), do: {:ok, :start}
  defp parse_char(<<a>>) when a in ?a..?z, do: {:ok, {:key, a}}
  defp parse_char(<<a>>) when a in ?A..?Z, do: {:ok, {:door, a}}

  defp print_cell(:wall), do: "#"
  defp print_cell(:floor), do: "."
  defp print_cell(:start), do: "@"
  defp print_cell({:key, a}), do: <<a>>
  defp print_cell({:door, a}), do: <<a>>

  def part_one(map) do
    Grid.print_map(map, &print_cell/1)
  end

  def part_two(problem) do
    problem
  end
end
