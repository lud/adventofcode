defmodule AdventOfCode.Solutions.Y23.Day13 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    input |> String.split("\n\n", trim: true) |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def part_one(patterns) do
    Enum.reduce(patterns, 0, fn pattern, sum ->
      {:ok, v} = compute_value(pattern)
      sum + v
    end)
  end

  def part_two(patterns) do
    Enum.reduce(patterns, 0, fn pattern, sum -> sum + compute_new_count(pattern) end)
  end

  defp compute_new_count(pattern) do
    {:ok, ignored} = compute_value(pattern)

    pattern
    |> stream_changes()
    |> Enum.find_value(fn new_pattern ->
      case compute_value(new_pattern, ignored) do
        :error -> nil
        {:ok, new_value} -> new_value
      end
    end)
  end

  defp stream_changes(pattern) do
    yo = length(pattern) - 1
    xo = (pattern |> hd() |> String.length()) - 1

    Stream.resource(
      fn -> {0, 0} end,
      fn
        {_, y} when y > yo -> raise "expleted"
        {x, y} when x > xo -> {[], {0, y + 1}}
        {x, y} -> {[fix_pattern(pattern, x, y)], {x + 1, y}}
      end,
      fn _ -> nil end
    )
  end

  defp fix_pattern(pattern, x, y) do
    List.update_at(pattern, y, fn <<prev::binary-size(x), c, rest::binary>> ->
      new_c =
        case c do
          ?. -> ?#
          ?# -> ?.
        end

      <<prev::binary-size(x), new_c, rest::binary>>
    end)
  end

  def compute_value(pattern, ignored \\ nil) do
    case h_reflection(pattern, ignored) do
      {:ok, v} -> {:ok, v}
      :error -> v_reflection(pattern, ignored)
    end
  end

  defp h_reflection(pattern, ignored) do
    abs_reflection(pattern, 100, ignored)
  end

  defp v_reflection(pattern, ignored) do
    pattern |> to_columns() |> abs_reflection(1, ignored)
  end

  defp abs_reflection(pattern, factor, ignored) do
    pattern
    |> Enum.chunk_every(2, 1)
    |> Enum.with_index()
    |> Enum.filter(fn
      # try to find two same horizontal lines
      {[same, same], _i} -> true
      _ -> false
    end)
    # There can be multiple duplicate lines, we have to try them all
    |> Enum.find_value(fn {_, i} ->
      case count_reflected_rows(pattern, i) do
        :error ->
          nil

        {:ok, v} ->
          case v * factor do
            ^ignored -> nil
            n -> {:ok, n}
          end
      end
    end)
    |> case do
      {:ok, v} -> {:ok, v}
      nil -> :error
    end
  end

  defp count_reflected_rows(pattern, i) do
    {top, bottom} = Enum.split(pattern, i + 1)
    revtop = :lists.reverse(top)

    if reflection?(revtop, bottom) do
      {:ok, length(revtop)}
    else
      :error
    end
  end

  defp to_columns([first_row | rest]) do
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
end
