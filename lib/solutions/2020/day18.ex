defmodule Aoe.Y20.Day18 do
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
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&parse_token/1)
    |> :lists.flatten()
    |> build_groups([])
  end

  defp parse_token("("), do: :open_block
  defp parse_token("(" <> rest), do: [:open_block, parse_token(rest)]
  defp parse_token(")"), do: :close_block
  defp parse_token(")" <> rest), do: [:close_block, parse_token(rest)]
  defp parse_token("+"), do: :+
  defp parse_token("*"), do: :*

  defp parse_token(int) do
    case Integer.parse(int) do
      {int, ""} -> int
      {int, rest} -> [int, parse_token(rest)]
      other -> raise "could not parse #{inspect(int)} as int: #{inspect(other)}"
    end
  end

  defp build_groups([:open_block | tokens], acc) do
    {block, rest} = extract_group(tokens, [])

    build_groups(rest, [{:block, block} | acc])
  end

  defp build_groups([tok | tokens], acc) when is_integer(tok) when tok in [:+, :*] do
    build_groups(tokens, [tok | acc])
  end

  defp build_groups([], acc) do
    :lists.reverse(acc)
  end

  defp extract_group([:close_block | tokens], acc) do
    {:lists.reverse(acc), tokens}
  end

  defp extract_group([:open_block | tokens], acc) do
    {block, rest} = extract_group(tokens, [])
    extract_group(rest, [{:block, block} | acc])
  end

  defp extract_group([tok | tokens], acc) when is_integer(tok) when tok in [:+, :*] do
    extract_group(tokens, [tok | acc])
  end

  def part_one(problem) do
    problem
    |> Enum.reduce(0, fn line, sum -> sum + eval_line_p1(line, nil) end)
  end

  defp eval_line_p1([first | line], nil) do
    eval_line_p1(line, eval_p1(first))
  end

  defp eval_line_p1([:+, next | rest], acc) do
    eval_line_p1(rest, acc + eval_p1(next))
  end

  defp eval_line_p1([:*, next | rest], acc) do
    eval_line_p1(rest, acc * eval_p1(next))
  end

  defp eval_line_p1([], acc) do
    acc
  end

  defp eval_p1(n) when is_integer(n), do: n
  defp eval_p1({:block, block}), do: eval_line_p1(block, nil)

  def part_two(problem) do
    problem
    |> Enum.map(&eval_line_p2/1)
    |> Enum.sum()
  end

  defp eval_line_p2(line) do
    line
    |> Enum.map(&reduce_expr/1)
    |> apply_additions
    |> apply_multiplications(nil)
  end

  defp apply_additions([n, :+, m | rest]) do
    added = n + m

    apply_additions([added | rest])
  end

  defp apply_additions([n, :*, m | rest]) do
    [eval_p2(n), :* | apply_additions([m | rest])]
  end

  defp apply_additions([last]) do
    [last]
  end

  defp apply_multiplications([n | rest], nil) when is_integer(n) do
    apply_multiplications(rest, n)
  end

  defp apply_multiplications([:*, n | rest], acc) when is_integer(n) do
    apply_multiplications(rest, acc * n)
  end

  defp apply_multiplications([], acc) do
    acc
  end

  defp reduce_expr({:block, block}) do
    eval_line_p2(block)
  end

  defp reduce_expr(other) do
    other
  end

  defp eval_p2(n) when is_integer(n), do: n
  defp eval_p2({:block, block}), do: eval_line_p2(block)
end
