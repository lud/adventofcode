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
      {:ok, v} = compute_value(pattern)
      v
    end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.with_index(1)
    |> Enum.map(fn {pattern, n} ->
      IO.puts(" == Pattern #{n} ==")
      compute_new_count(pattern)
    end)
    |> Enum.sum()
  end

  defp compute_new_count(pattern) do
    {:ok, old_value} = compute_value(pattern)

    old_value |> IO.inspect(label: ~S/old_value/)

    pattern
    |> stream_changes()
    |> Enum.find_value(fn new_pattern ->
      case compute_value(new_pattern, old_value) do
        :error ->
          nil

        {:ok, ^old_value} ->
          raise "found same"
          IO.puts("FOUND SAME VALUE")
          nil

        {:ok, new_value} ->
          new_value
      end
    end)
  end

  defp stream_changes(pattern) do
    yo = length(pattern) - 1
    xo = (pattern |> hd() |> String.length()) - 1
    print_pattern(pattern)

    Stream.resource(
      fn -> {0, 0} end,
      fn
        {_, y} when y > yo ->
          IO.puts("could not find smudge -----------------")
          print_pattern(pattern)
          raise "expleted"

        {x, y} when x > xo ->
          {[], {0, y + 1}}

        {x, y} ->
          y |> IO.inspect(label: ~S/y/)
          x |> IO.inspect(label: ~S/x/)
          {[fix_pattern(pattern, x, y)], {x + 1, y}}
      end,
      fn _ -> nil end
    )
    |> Stream.map(&print_pattern/1)
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

  def compute_value(pattern, ignore_value \\ nil) do
    case h_reflection(pattern, ignore_value) do
      {:ok, v} -> {:ok, v}
      :error -> v_reflection(pattern, ignore_value)
    end
  end

  defp maybe_div_100(nil), do: nil
  defp maybe_div_100(n) when n >= 100, do: div(n, 100)
  defp maybe_div_100(n), do: n

  defp h_reflection(pattern, ignore_value) do
    abs_reflection(pattern, 100, ignore_value)
  end

  defp abs_reflection(pattern, factor, ignore_value) do
    pattern
    |> Enum.chunk_every(2, 1)
    |> Enum.with_index()
    |> Enum.filter(fn
      # try to find two same horizontal lines
      {[same, same], i} ->
        same |> IO.inspect(label: ~S/same/)
        i |> IO.inspect(label: ~S/i/)
        true

      _ ->
        false
    end)
    # There can be multiple duplicate lines, we have to try them all
    |> Enum.find_value(fn {_, i} ->
      i |> IO.inspect(label: ~S/i/)
      ignore_value |> IO.inspect(label: ~S/ignore_value/)

      case count_relfected_rows(pattern, i) do
        :error ->
          nil

        {:ok, v} ->
          case v * factor do
            ^ignore_value -> nil
            n -> {:ok, n}
          end
      end
    end)
    |> case do
      {:ok, ^ignore_value} -> raise "could not ignore horizontal"
      {:ok, v} -> {:ok, v}
      nil -> :error
    end
  end

  defp count_relfected_rows(pattern, i) do
    pattern |> IO.inspect(label: ~S/pattern in count/)
    i |> IO.inspect(label: ~S/i/)
    {top, bottom} = Enum.split(pattern, i + 1)
    revtop = :lists.reverse(top)
    revtop |> IO.inspect(label: ~S/revtop/)

    case reflection?(revtop, bottom) do
      true -> {:ok, length(revtop)}
      false -> :error
    end
    |> dbg()
  end

  defp v_reflection(pattern, ignore_value) do
    pattern = to_columns(pattern) |> abs_reflection(1, ignore_value)
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
end
