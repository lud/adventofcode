defmodule AdventOfCode.Y22.Day25 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input
  end

  def part_one(problem) do
    problem
    |> Enum.map(&parse_snafu/1)
    |> Enum.sum()
    |> encode_snafu()
  end

  def parse_snafu(text) do
    text
    |> String.graphemes()
    |> Enum.map(&parse_digit/1)
    |> :lists.reverse()
    |> Enum.zip_with(powers(), &Kernel.*/2)
    |> Enum.sum()
  end

  defp powers do
    Stream.unfold(0, fn acc -> {5 ** acc, acc + 1} end)
  end

  defp parse_digit("0"), do: 0
  defp parse_digit("1"), do: 1
  defp parse_digit("2"), do: 2
  defp parse_digit("="), do: -2
  defp parse_digit("-"), do: -1

  def encode_snafu(n) do
    Enum.reduce_while(powers(), [], fn p, acc ->
      if p < n do
        {:cont, [p | acc]}
      else
        {:halt, [p | acc]}
      end
    end)
    |> Enum.reduce({n, []}, fn pow, {n, acc} ->
      {v, rest} = divrem(n, pow)
      {rest, [{v, pow} | acc]}
    end)
    |> elem(1)
    |> Enum.with_index()
    |> Enum.map(fn {{x, _pow}, index} -> {index, x} end)
    |> Map.new()
    |> loop()
    |> Map.to_list()
    |> Enum.sort()
    |> Enum.map(
      &case &1 do
        {_, -2} -> "="
        {_, -1} -> "-"
        {_, 0} -> "0"
        {_, 1} -> "1"
        {_, 2} -> "2"
      end
    )
    |> :lists.reverse()
    |> Enum.join()
    |> String.trim_leading("0")
  end

  defp loop(map) do
    case Enum.find(map, fn {_index, v} -> v > 2 end) do
      nil -> map
      {index, _} -> map |> map_add(index, -5) |> map_add(index + 1, 1) |> loop
    end
  end

  defp map_add(map, index, value) do
    Map.update(map, index, value, &(&1 + value))
  end

  defp divrem(n, d) do
    {div(n, d), rem(n, d)}
  end

  def part_two(_) do
    -1
  end
end
