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
    {blocks, max_block} = build_disk(problem)
    max_block = last_occupied(blocks, max_block)
    blocks = compress(blocks, 0, max_block)
    hash(blocks)
  end

  defp build_disk(problem) do
    build_disk(problem, :file, 0, 0, [])
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

  defp last_occupied(_, -1) do
    nil
  end

  defp compress(blocks, current, last_occup) when :erlang.map_get(current, blocks) == :free do
    {file_id, blocks} = Map.pop(blocks, last_occup)
    blocks = Map.put(blocks, current, file_id)
    compress(blocks, current + 1, last_occupied(blocks, last_occup))
  end

  defp compress(blocks, current, last_occup) when last_occup > current do
    compress(blocks, current + 1, last_occup)
  end

  defp compress(blocks, _, _) do
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
    Enum.reduce(blocks, 0, fn
      {i, f}, acc when is_integer(f) -> acc + i * f
      {_, :free}, acc -> acc
    end)
  end

  def part_two(problem) do
    {blocks, max_block} = build_disk(problem)
    max_block = last_occupied(blocks, max_block)
    blocks = defrag(blocks, 0, max_block)
    hash(blocks)
  end

  defp defrag(blocks, _, nil) do
    blocks
  end

  defp defrag(blocks, search_start, last_occup) do
    {file_id, [start_at | _] = block_ids} = last_block(blocks, last_occup)
    block_size = length(block_ids)

    {blocks, search_start} =
      case find_space(blocks, block_size, search_start, start_at - block_size) do
        nil ->
          {blocks, search_start}

        new_start ->
          blocks = rewrite_file(blocks, file_id, block_ids, range(new_start, block_size))
          search_start = first_free_index(blocks, search_start)
          {blocks, search_start}
      end

    defrag(blocks, search_start, last_occupied(blocks, start_at - 1))
  end

  defp last_block(blocks, last_occup) when is_integer(last_occup) do
    file_id = Map.fetch!(blocks, last_occup)

    block_ids =
      last_occup
      |> Stream.iterate(&(&1 - 1))
      |> Enum.take_while(&(&1 >= 0 && Map.get(blocks, &1) == file_id))
      |> :lists.reverse()

    {file_id, block_ids}
  end

  defp find_space(blocks, size, min_start, max_start) when min_start <= max_start do
    Enum.find(min_start..max_start, fn start -> free_span?(blocks, start, size) end)
  end

  defp find_space(_, _, _, _) do
    nil
  end

  defp free_span?(blocks, i, size) when size > 0 do
    Map.get(blocks, i) == :free && free_span?(blocks, i + 1, size - 1)
  end

  defp free_span?(_, _, 0) do
    true
  end

  defp range(_, 0), do: []
  defp range(x, n), do: [x | range(x + 1, n - 1)]

  defp rewrite_file(blocks, file_id, block_ids, new_block_ids) do
    blocks
    |> Map.drop(block_ids)
    |> Map.merge(Map.new(new_block_ids, &{&1, file_id}))
  end

  defp first_free_index(blocks, search_start) do
    Enum.find(search_start..(map_size(blocks) - search_start), &(Map.get(blocks, &1) == :free))
  end
end
