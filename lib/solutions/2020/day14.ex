defmodule Aoe.Y20.Day14 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input(input, _part) do
    input
    |> Stream.map(&parse_line/1)
  end

  defp parse_line("mask = " <> line) do
    mask =
      line
      |> String.to_charlist()
      |> :lists.reverse()
      |> Enum.map(fn
        ?X -> :X
        ?0 -> 0
        ?1 -> 1
      end)
      |> Enum.with_index()

    {:mask, mask}
  end

  @re_op ~r/^mem\[(\d+)\] = (\d+)$/

  defp parse_line(op) do
    [addr, val] = Regex.run(@re_op, op, capture: :all_but_first)
    {:value, {String.to_integer(addr), String.to_integer(val)}}
  end

  def initial() do
    %{}
  end

  def part_one(stream) do
    stream
    |> Enum.reduce({initial(), nil}, &handle_input_p1/2)
    |> elem(0)
    |> Enum.reduce(0, fn {_, val}, acc -> val + acc end)
  end

  defp handle_input_p1({:mask, mask}, {map, _old_mask}) do
    mask = Enum.reject(mask, fn {bit, _} -> bit == :X end)
    {map, mask}
  end

  defp handle_input_p1({:value, {addr, value}}, {map, mask}) do
    map = Map.put(map, addr, mask_value(value, mask))
    {map, mask}
  end

  defp mask_value(value, mask) do
    masked =
      Enum.reduce(mask, <<value::integer-36>>, fn {bit, pos}, bin ->
        left_bits = 36 - pos - 1
        right_bits = pos
        <<left::size(left_bits), _::size(1), right::size(right_bits)>> = bin
        <<left::size(left_bits), bit::size(1), right::size(right_bits)>>
      end)

    <<masked::integer-36>> = masked
    masked
  end

  def part_two(stream) do
    stream
    |> Enum.reduce({initial(), nil}, &handle_input_p2/2)
    |> elem(0)
    |> Enum.reduce(0, fn {_, val}, acc -> val + acc end)
  end

  defp handle_input_p2({:mask, mask}, {map, _old_mask}) do
    {map, mask}
  end

  defp handle_input_p2({:value, {addr, value}}, {map, mask}) do
    addresses = mask_addrs([addr], mask) |> :lists.flatten()
    map = Enum.reduce(addresses, map, &Map.put(&2, &1, value))
    {map, mask}
  end

  defp mask_addrs(addrs, [{0, _} | mask]) do
    mask_addrs(addrs, mask)
  end

  defp mask_addrs(addrs, [{1, pos} | mask]) do
    addrs = Enum.map(addrs, &set_bit(&1, pos, 1))
    mask_addrs(addrs, mask)
  end

  defp mask_addrs(addrs, [{:X, pos} | mask]) do
    [
      mask_addrs(Enum.map(addrs, &set_bit(&1, pos, 0)), mask),
      mask_addrs(Enum.map(addrs, &set_bit(&1, pos, 1)), mask)
    ]
  end

  defp mask_addrs(addrs, []) do
    addrs
  end

  defp set_bit(addr, pos, v) do
    left_bits = 36 - pos - 1
    right_bits = pos
    <<left::size(left_bits), _::size(1), right::size(right_bits)>> = <<addr::integer-36>>
    <<masked::integer-36>> = <<left::size(left_bits), v::size(1), right::size(right_bits)>>
    masked
  end
end
