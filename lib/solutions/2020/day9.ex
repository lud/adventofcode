defmodule Aoe.Y20.Day9 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file(file, _part) do
    # Input.read!(file)
    # Input.stream!(file)
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input(input, _part) do
    input
    |> Input.stream_to_integers()
    |> Enum.to_list()
  end

  def to_chunks(problem, preamble_len) do
    problem
    |> Enum.reverse()
    |> Enum.chunk_every(preamble_len + 1, 1, :discard)
    |> Enum.reverse()
  end

  def part_one(problem, preamble_len \\ 25) do
    chunks = to_chunks(problem, preamble_len)

    find_bad_chunk(chunks)
  end

  def find_bad_chunk([chunk | chunks]) do
    [sum | candidates] = chunk

    case check_chunk(sum, candidates) do
      {:invalid, ^sum} -> sum
      :valid -> find_bad_chunk(chunks)
    end
  end

  def check_chunk(sum, [c | candidates]) do
    case Enum.find(candidates, fn cd -> c + cd == sum end) do
      nil -> check_chunk(sum, candidates)
      _cd -> :valid
    end
  end

  def check_chunk(sum, []) do
    {:invalid, sum}
  end

  def part_two(problem, preamble_len \\ 25) do
    target = part_one(problem, preamble_len)
    nums = find_contiguous(target, problem)
    Enum.min(nums) + Enum.max(nums)
  end

  def find_contiguous(target, [h | problem]) do
    case find_contiguous(target, problem, h, [h]) do
      {:ok, acc} -> acc
      :error -> find_contiguous(target, problem)
    end
  end

  def find_contiguous(target, [h | _], sum, acc) when h + sum == target do
    {:ok, [h | acc]}
  end

  def find_contiguous(target, [h | problem], sum, acc) when h + sum < target do
    find_contiguous(target, problem, sum + h, [h | acc])
  end

  def find_contiguous(_, _, _, _) do
    :error
  end
end
