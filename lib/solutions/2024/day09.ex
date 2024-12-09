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
    rev_blocks = build_disk(problem)
    blocks = :lists.reverse(rev_blocks)
    blocks = compress(blocks, Enum.filter(rev_blocks, fn {_, v} -> v != :free end), [])
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

  defp build_disk([], _, _, _, acc) do
    acc
  end

  defp compress([{bid, :free} | blocks], [{fbid, file_id} | movables], acc) when bid <= fbid do
    compress(blocks, movables, [{bid, file_id} | acc])
  end

  defp compress([{bid, file_id} | blocks], [{fbid, _} | _] = movables, acc) when bid <= fbid do
    compress(blocks, movables, [{bid, file_id} | acc])
  end

  defp compress(_blocks, _movables, acc) do
    acc
  end

  defp hash(blocks) do
    Enum.reduce(blocks, 0, fn
      {i, f}, acc when is_integer(f) -> acc + i * f
      {_, :free}, acc -> acc
    end)
  end

  def part_two(problem) do
    rev_blocks = build_disk(problem)

    {free_chunks, files_chunks} =
      rev_blocks
      |> :lists.reverse()
      |> Enum.chunk_by(fn {_, v} -> v end)
      |> Enum.map(fn [{_, fid_or_free} | _] = list ->
        {Enum.map(list, &elem(&1, 0)), fid_or_free}
      end)
      |> Enum.split_with(fn {_, id} -> id == :free end)

    free_chunks = Enum.map(free_chunks, fn {bids, :free} -> {bids, length(bids)} end)
    rev_files_chunks = :lists.reverse(files_chunks)
    blocks = defrag(rev_files_chunks, free_chunks, [])
    hash2(blocks)
  end

  defp defrag([{[low_bid | _] = bids, file_id} = h | rev_files_chunks], [{[high_free | _], _} | _] = free_chunks, acc)
       when high_free < low_bid do
    space = take_space(free_chunks, bids)

    [bid | _] = bids

    case space do
      {[free_bid | _] = free_bids, free_chunks} when free_bid < bid ->
        defrag(rev_files_chunks, free_chunks, [{free_bids, file_id} | acc])

      _ ->
        defrag(rev_files_chunks, free_chunks, [h | acc])
    end
  end

  defp defrag(rest, _, acc) do
    rest ++ acc
  end

  defp take_space(free_chunks, bids) do
    take_space(free_chunks, length(bids), [])
  end

  defp take_space([{vids, larger_len} | rest], len, skipped) when len < larger_len do
    {vids_used, vids_rest} = Enum.split(vids, len)
    {vids_used, :lists.reverse(skipped, [{vids_rest, larger_len - len} | rest])}
  end

  defp take_space([{vids, same_len} | rest], same_len, skipped) do
    {vids, :lists.reverse(skipped, rest)}
  end

  defp take_space([skip | rest], len, skipped) do
    take_space(rest, len, [skip | skipped])
  end

  defp take_space([], _, _) do
    nil
  end

  defp hash2(blocks) do
    Enum.reduce(blocks, 0, fn
      {bids, f}, acc when is_integer(f) -> Enum.reduce(bids, acc, fn b, acc -> acc + b * f end)
    end)
  end
end
