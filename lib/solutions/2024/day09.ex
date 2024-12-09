defmodule AdventOfCode.Solutions.Y24.Day09 do
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.read!()
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def part_one(problem) do
    {blocks, max_block} = build_disk(problem, :file, 0, 0, [])
    max_block = last_occupied(blocks, max_block)
    blocks = defrag(blocks, 0, max_block)
    hash(blocks)
  end

  defp build_disk([0 | t], :file, block_id, file_id, acc) do
    build_disk(t, :free, block_id, file_id + 1, acc)
  end

  defp build_disk([0 | t], :free, block_id, file_id, acc) do
    build_disk(t, :file, block_id, file_id, acc)
  end

  defp build_disk([h | t], :file, block_id, file_id, acc) do
    build_disk([h - 1 | t], :file, block_id + 1, file_id, [{block_id, file_id} | acc])
  end

  defp build_disk([h | t], :free, block_id, file_id, acc) do
    build_disk([h - 1 | t], :free, block_id + 1, file_id, [{block_id, :free} | acc])
  end

  defp build_disk([], _, block_id, _, acc) do
    {Map.new(acc), block_id - 1}
  end

  defp last_occupied(blocks, index) when is_integer(:erlang.map_get(index, blocks)) do
    index
  end

  defp last_occupied(blocks, index) when index > 0 do
    last_occupied(blocks, index - 1)
  end

  defp defrag(blocks, current, last_occup) when :erlang.map_get(current, blocks) == :free do
    {file_id, blocks} = Map.pop(blocks, last_occup)
    blocks = Map.put(blocks, current, file_id)
    # print(blocks)
    defrag(blocks, current + 1, last_occupied(blocks, last_occup))
  end

  defp defrag(blocks, current, last_occup) when last_occup > current do
    defrag(blocks, current + 1, last_occup)
  end

  defp defrag(blocks, _, _) do
    blocks
  end

  defp print(blocks) do
    blocks
    |> Map.to_list()
    |> Enum.sort()
    |> Enum.map(fn
      {_, :free} -> ?.
      {_, v} -> Integer.to_string(v)
    end)
    |> IO.puts()

    blocks
  end

  defp hash(blocks) do
    blocks
    |> Map.to_list()
    |> Enum.reduce(0, fn
      {i, f}, acc when is_integer(f) -> acc + i * f
      {i, :free}, acc -> acc
    end)
  end

  # def part_two(problem) do
  #   problem
  # end
end
