defmodule AdventOfCode.Y15.Day11 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.read!(file) |> String.trim()
  end

  def parse_input(input, _part) do
    input |> String.to_charlist()
  end

  def part_one(problem) do
    problem
    |> increment()
    |> Stream.iterate(&increment/1)
    |> Stream.filter(&valid?/1)
    |> Enum.take(1)
    |> to_string()
  end

  def part_two(problem) do
    problem
    |> increment()
    |> Stream.iterate(&increment/1)
    |> Stream.filter(&valid?/1)
    |> Enum.take(2)
    |> List.last()
    |> to_string()
  end

  defp valid?(chars) do
    not invalid_chars?(chars) &&
      has_straight?(chars) &&
      has_two_pairs?(chars)
  end

  defp invalid_chars?([?i | _]), do: true
  defp invalid_chars?([?o | _]), do: true
  defp invalid_chars?([?l | _]), do: true
  defp invalid_chars?([_ | t]), do: invalid_chars?(t)
  defp invalid_chars?([]), do: false

  defp has_straight?([a, b, c | _]) when a + 1 == b and b + 1 == c, do: true
  defp has_straight?([_, _]), do: false
  defp has_straight?([_ | t]), do: has_straight?(t)

  defp has_two_pairs?(chars) do
    has_two_pairs?(chars, nil)
  end

  defp has_two_pairs?([a, a | t], nil) do
    has_two_pairs?(t, a)
  end

  defp has_two_pairs?([a, a | _], prev) when a != prev do
    true
  end

  defp has_two_pairs?([_, a | t], prev) do
    has_two_pairs?([a | t], prev)
  end

  defp has_two_pairs?([_], _) do
    false
  end

  defp has_two_pairs?([], _) do
    false
  end

  defp increment(chars) do
    {:ok, next} = do_increment(chars)
    next
  end

  defp do_increment([?z]) do
    {:up, [?a]}
  end

  defp do_increment([c]) do
    {:ok, [c + 1]}
  end

  defp do_increment([c | t]) do
    case do_increment(t) do
      {:ok, new_t} ->
        {:ok, [c | new_t]}

      {:up, new_t} ->
        case c do
          ?z -> {:up, [?a | new_t]}
          c -> {:ok, [c + 1 | new_t]}
        end
    end
  end

  # def part_two(problem) do
  #   problem
  # end
end
