defmodule Aoe.Y22.Day20 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input |> Enum.map(&String.to_integer/1)
  end

  def part_one(nums) do
    indexed = Enum.with_index(nums, 0)
    map = scan(indexed)

    size = map_size(map)

    map = Enum.reduce(indexed, map, fn {_, i}, acc -> move_num(i, acc, size) end)

    i0 = index_of(map, 0)

    i1000th = forward(map, i0, 1000)
    i2000th = forward(map, i0, 2000)
    i3000th = forward(map, i0, 3000)

    n1000th = Map.fetch!(map, i1000th) |> Map.fetch!(:face)
    n2000th = Map.fetch!(map, i2000th) |> Map.fetch!(:face)
    n3000th = Map.fetch!(map, i3000th) |> Map.fetch!(:face)

    n1000th + n2000th + n3000th
  end

  def part_two(problem) do
    nums = Enum.map(problem, &(&1 * 811_589_153))
    indexed = Enum.with_index(nums, 0)
    map = scan(indexed)

    size = map_size(map)

    map =
      Enum.reduce(1..10, map, fn _, map ->
        Enum.reduce(indexed, map, fn {_, i}, acc -> move_num(i, acc, size) end)
      end)

    i0 = index_of(map, 0)

    i1000th = forward(map, i0, 1000)
    i2000th = forward(map, i0, 2000)
    i3000th = forward(map, i0, 3000)

    n1000th = Map.fetch!(map, i1000th) |> Map.fetch!(:face)
    n2000th = Map.fetch!(map, i2000th) |> Map.fetch!(:face)
    n3000th = Map.fetch!(map, i3000th) |> Map.fetch!(:face)

    n1000th + n2000th + n3000th
  end

  defp index_of(map, face) do
    x = Enum.find(map, fn {_, %{face: n}} -> n == face end)
    elem(x, 0)
  end

  defp move_num(n, map, size) do
    %{face: face} = byte = Map.fetch!(map, n)

    case face do
      0 -> map
      _ -> do_move(n, byte, map, size)
    end
  end

  defp do_move(n, %{face: face, next: self_next, prev: self_prev}, map, size) do
    map = Map.update!(map, self_prev, fn x -> %{x | next: self_next} end)
    map = Map.update!(map, self_next, fn x -> %{x | prev: self_prev} end)

    target =
      cond do
        face > 0 -> forward(map, n, rem(face, size - 1))
        face < 0 -> rewind(map, n, rem(face, size - 1) - 1)
      end

    %{next: target_next} = Map.fetch!(map, target)

    map = Map.update!(map, target, fn x -> %{x | next: n} end)
    map = Map.update!(map, target_next, fn x -> %{x | prev: n} end)
    map = Map.update!(map, n, fn x -> %{x | prev: target, next: target_next} end)

    map
  end

  defp forward(map, n, pos) when pos > 0 do
    %{next: next} = Map.fetch!(map, n)
    forward(map, next, pos - 1)
  end

  defp forward(_, n, 0) do
    n
  end

  defp rewind(map, n, pos) when pos < 0 do
    %{prev: prev} = Map.fetch!(map, n)
    rewind(map, prev, pos + 1)
  end

  defp rewind(_, n, 0) do
    n
  end

  defp scan(nums) do
    [{_, i_h} | _] = nums

    [{l, %{} = last} | list] = scan(nums, nil, [])
    last = %{last | next: i_h}
    [{f, first} | list] = :lists.reverse([{l, last} | list])
    first = %{first | prev: l}
    list = [{f, first} | list]

    Map.new(list)
  end

  defp scan([{h, i}, {_, i_next} = next | t], i_prev, acc) do
    scan([next | t], i, [{i, %{face: h, prev: i_prev, next: i_next}} | acc])
  end

  defp scan([{h, i}], i_prev, acc) do
    [{i, %{face: h, prev: i_prev, next: nil}} | acc]
  end
end
