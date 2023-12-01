defmodule AdventOfCode.Y20.Day20FirstTry do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    input
    |> String.split(~r/\n{2,}/, trim: true)
    |> Enum.map(&parse_tile/1)
    |> Map.new()
    |> IO.inspect(label: "map")
  end

  defdelegate stc(str), to: String, as: :to_charlist

  defp parse_tile("Tile " <> rest) do
    [header | rows] = String.split(rest, "\n", trim: true)
    {id, ":"} = Integer.parse(header)
    {id, rows}
  end

  def part_one(map, return_data? \\ false) do
    map =
      map
      |> Enum.map(&tile_with_signatures/1)
      |> Map.new()

    sign2neighbours = map |> Enum.reduce(%{}, &register_signatures/2)

    neighbourcounts =
      sign2neighbours
      |> Enum.reduce(%{}, &count_neighbours/2)

    corners =
      neighbourcounts
      |> Enum.filter(fn {_id, count} -> count == 2 end)

    if return_data? do
      {map, sign2neighbours, neighbourcounts, corners}
    else
      corners
      |> Enum.map(&elem(&1, 0))
      |> Enum.reduce(&(&1 * &2))
    end
  end

  defp tile_with_signatures({id, rows}) do
    rows = rows |> Enum.map(&stc/1)
    top_row = rows |> hd
    bottom_row = rows |> List.last()
    left_col = rows |> Enum.map(&hd/1)
    rigth_col = rows |> Enum.map(&List.last/1)

    # tile =
    #   for {row, y} <- Enum.with_index(rows),
    #       {char, x} <- Enum.with_index(stc(row)),
    #       into: %{} do
    #     {{x, y}, char}
    #   end

    # {id,
    #  %{
    #    top: signature(top_row),
    #    bottom: signature(bottom_row),
    #    left: signature(left_col),
    #    right: signature(rigth_col)
    #  }}
    {id,
     %{
       signatures: [
         signature(top_row),
         signature(bottom_row),
         signature(left_col),
         signature(rigth_col)
       ]
     }}
  end

  defp register_signatures({id, %{signatures: signatures}}, acc) do
    Enum.reduce(signatures, acc, fn sign, acc ->
      Map.update(acc, sign, [id], &[id | &1])
    end)
  end

  defp count_neighbours({_sign, ids}, acc) do
    case ids do
      # This side signature corresponds to two tiles, so each tile is the neighbour of the other, we add +1 neighbour to each tile id
      [id_a, id_b] ->
        acc
        |> Map.update(id_a, 1, &(&1 + 1))
        |> Map.update(id_b, 1, &(&1 + 1))

      # This side is a border
      [_alone] ->
        acc
    end
  end

  defp signature(chars) do
    rev = :lists.reverse(chars)
    [a, b] = :lists.sort([chars, rev])
    :lists.flatten([a, ~c"|", b])
  end

  def part_two(map) do
    {_map, sign2neighbours, _neighbourcounts, _corners} = part_one(map, true)

    sign2neighbours
    |> Enum.sort(&(length(elem(&1, 1)) <= length(elem(&2, 1))))
  end
end
