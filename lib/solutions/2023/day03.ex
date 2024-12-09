defmodule AdventOfCode.Solutions.Y23.Day03 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    AdventOfCode.Grid.parse_lines(input, &parse_char/1) |> elem(0)
  end

  defp parse_char(n) when n in ?0..?9, do: {:ok, n - ?0}
  defp parse_char(?.), do: :ignore
  defp parse_char(?*), do: {:ok, :gear}
  defp parse_char(_), do: {:ok, :sym}

  def part_one(grid) do
    grid
    |> Enum.filter(fn {xy, val} -> is_integer(val) and sym_neighbour?(grid, xy) end)
    |> Enum.map(fn {xy, _} -> first_digit(grid, xy) end)
    |> Enum.uniq()
    |> Enum.map(&collect_number(grid, &1))
    |> Enum.sum()
  end

  defp sym_neighbour?(grid, xy) do
    xy |> AdventOfCode.Grid.cardinal8() |> Enum.any?(fn txy -> Map.get(grid, txy) in [:sym, :gear] end)
  end

  defp first_digit(grid, xy) do
    west_xy = AdventOfCode.Grid.translate(xy, :w)

    case Map.get(grid, west_xy) do
      n when is_integer(n) -> first_digit(grid, west_xy)
      _ -> xy
    end
  end

  defp collect_number(grid, xy) do
    collect_number(grid, xy, [Map.fetch!(grid, xy)])
  end

  defp collect_number(grid, xy, acc) do
    east_xy = AdventOfCode.Grid.translate(xy, :e)

    case Map.get(grid, east_xy) do
      n when is_integer(n) -> collect_number(grid, east_xy, [n | acc])
      _ -> acc |> :lists.reverse() |> Integer.undigits()
    end
  end

  # -- Part 2 -----------------------------------------------------------------

  def part_two(grid) do
    grid
    # For each digit in the grid, associate the digit XY with the neighbouring
    # gear XY, keeping only digits with such neighbour.
    |> Enum.flat_map(fn
      {xy, val} when is_integer(val) ->
        case gear_neighbour(grid, xy) do
          nil -> []
          gear_xy -> [{gear_xy, xy}]
        end

      _ ->
        []
    end)
    # Group those digits XY by their neighbouring gear XY.
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    # Transform the digits XY into the first digit XY of their number
    |> Enum.flat_map(fn {_gear_xy, digits_xys} ->
      first_digits = digits_xys |> Enum.map(&first_digit(grid, &1)) |> Enum.uniq()
      # Keep only the gear groups with exactly two numbers. Collect the actual
      # numbers and compute the product.
      case first_digits do
        [digit_a_xy, digit_b_xy] ->
          num_a = collect_number(grid, digit_a_xy)
          num_b = collect_number(grid, digit_b_xy)
          [num_a * num_b]

        _ ->
          []
      end
    end)
    |> Enum.reduce(&Kernel.+/2)
  end

  defp gear_neighbour(grid, xy) do
    xy |> AdventOfCode.Grid.cardinal8() |> Enum.find(fn txy -> Map.get(grid, txy) == :gear end)
  end
end
