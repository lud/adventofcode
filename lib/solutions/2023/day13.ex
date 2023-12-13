defmodule AdventOfCode.Y23.Day13 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    input |> String.split("\n\n", trim: true) |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def part_one(patterns) do
    patterns
    |> Enum.with_index(1)
    |> Enum.map(fn {pattern, n} ->
      IO.puts(" == Pattern #{n} ==")
      compute_value(pattern)
    end)
    |> Enum.sum()
  end

  defp compute_value(pattern) do
    case h_reflection(pattern) do
      {:ok, v} ->
        v * 100

      :error ->
        case v_reflection(pattern) do
          {:ok, v} ->
            v

          :error ->
            print_pattern(pattern)
            raise "bad pattern"
        end
    end
  end

  defp h_reflection(pattern) do
    pattern
    |> Enum.chunk_every(2, 1)
    |> Enum.with_index()
    |> Enum.filter(fn
      # try to find two same horizontal lines
      {[same, same], i} -> true
      _ -> false
    end)
    # There can be multiple duplicate lines, we have to try them all
    |> Enum.find_value(fn {_, i} ->
      case count_h_reflection(pattern, i) do
        {:ok, v} -> {:ok, v}
        :error -> nil
      end
    end)
    |> case do
      {:ok, v} -> {:ok, v}
      nil -> :error
    end
  end

  defp count_h_reflection(pattern, i) do
    {top, bottom} = Enum.split(pattern, i + 1)
    revtop = :lists.reverse(top)

    case reflection?(revtop, bottom) do
      true -> {:ok, length(revtop)}
      false -> :error
    end
  end

  defp v_reflection(pattern) do
    pattern = to_columns(pattern) |> h_reflection()
  end

  defp to_columns([first_row | rest] = p) do
    first_col =
      first_row
      |> String.graphemes()
      |> Enum.map(fn v -> [v] end)

    Enum.reduce(rest, first_col, fn row, acc ->
      row |> String.graphemes() |> Enum.zip_with(acc, fn v, col -> [v | col] end)
    end)
    |> Enum.map(&Enum.join(&1))
  end

  defp reflection?([h | t1], [h | t2]) do
    reflection?(t1, t2)
  end

  defp reflection?([], _) do
    true
  end

  defp reflection?(_, []) do
    true
  end

  defp reflection?(_, _) do
    false
  end

  defp print_pattern(pattern) do
    Enum.intersperse(pattern, "\n") |> Enum.join() |> IO.puts()
    pattern
  end

  # def part_two(problem) do
  #   problem
  # end
end
