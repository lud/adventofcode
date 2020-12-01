defmodule Aoe.Y20.Day1 do
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
    |> Input.stream_to_integers()
    |> Enum.to_list()
  end

  @spec part_one(problem) :: integer
  def part_one(problem) do
    problem
    |> find_summable(2020)
    |> multiply()
  end

  @spec part_two(problem) :: integer
  def part_two(problem) do
    problem
    |> find_three_summable(2020)
    |> multiply()
  end

  defp find_three_summable(list, checksum) do
    Enum.find_value(list, fn v ->
      case find_summable(list, checksum - v) do
        {a, b} -> {v, a, b}
        nil -> nil
      end
    end)
  end

  defp find_summable([h | t], checksum) do
    find_summable(h, t, checksum)
  end

  defp find_summable([], _checksum) do
    nil
  end

  defp find_summable(h, t, checksum) do
    case Enum.find(t, fn v -> h + v == checksum end) do
      nil -> find_summable(t, checksum)
      v -> {h, v}
    end
  end

  defp multiply({a, b}) do
    a * b
  end

  defp multiply({a, b, c}) do
    a * b * c
  end
end
