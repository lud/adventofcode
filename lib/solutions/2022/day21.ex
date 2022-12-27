defmodule Aoe.Y22.Day21 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    input |> Map.new(&parse_line/1)
  end

  defp parse_line(<<label::binary-size(4), ": ", math::binary>>) do
    case Integer.parse(math) do
      {n, ""} -> {label, {:val, n}}
      _ -> {label, {:op, parse_op(math)}}
    end
  end

  defp parse_op(<<left::binary-size(4), " ", op::binary-size(1), " ", right::binary-size(4)>>) do
    {String.to_atom(op), left, right}
  end

  def part_one(problem) do
    solved =
      Enum.filter(problem, fn
        {_, {:val, _}} -> true
        _ -> false
      end)
      |> Map.new(fn {k, {:val, n}} -> {k, n} end)

    solved = resolve(problem, ["root"], solved)
    solved["root"]
  end

  defp resolve(problem, [cur | stack], solved) do
    case Map.fetch!(problem, cur) do
      {:op, {op, left, right}} ->
        case {Map.fetch(solved, left), Map.fetch(solved, right)} do
          {{:ok, l}, {:ok, r}} -> resolve(problem, stack, Map.put(solved, cur, calc(op, l, r)))
          {:error, {:ok, _}} -> resolve(problem, [left, cur | stack], solved)
          {{:ok, _}, :error} -> resolve(problem, [right, cur | stack], solved)
          {:error, :error} -> resolve(problem, [left, right, cur | stack], solved)
        end

      {:val, n} ->
        resolve(problem, stack, Map.put(solved, cur, n))
    end
  end

  defp resolve(_, [], solved) do
    solved
  end

  defp calc(:+, a, b), do: a + b
  defp calc(:-, a, b), do: a - b
  defp calc(:*, a, b), do: a * b
  defp calc(:/, a, b), do: div(a, b)

  def part_two(problem) do
    solved =
      Enum.filter(problem, fn
        {_, {:val, _}} -> true
        _ -> false
      end)
      |> Map.new(fn {k, {:val, n}} -> {k, n} end)
      |> Map.delete("humn")

    {reduced, _} =
      problem
      |> Map.update!("humn", fn {:val, _} -> :you end)
      |> Map.update!("root", fn {:op, {_, l, r}} -> {:EQUAL, l, r} end)
      |> Map.new()
      |> preloop(solved)

    # now one of the two equality checks is hopefully a value
    {:EQUAL, left, right} = Map.fetch!(reduced, "root")

    {label, value} =
      case Map.fetch!(reduced, left) do
        {:val, v} ->
          {right, v}

        {:op, _} ->
          {:val, v} = Map.fetch!(reduced, right)
          {left, v}
      end

    # now we know that label value must be equal to value

    equation = nest_ops(reduced, label)

    run_equation(equation, value)
  end

  defp run_equation({:+, {_, _, _} = next, int}, value) when is_integer(int) do
    run_equation(next, value - int)
  end

  defp run_equation({:/, {_, _, _} = next, int}, value) when is_integer(int) do
    run_equation(next, value * int)
  end

  defp run_equation({:+, int, {_, _, _} = next}, value) when is_integer(int) do
    run_equation(next, value - int)
  end

  defp run_equation({:*, int, {_, _, _} = next}, value) when is_integer(int) do
    run_equation(next, div(value, int))
  end

  defp run_equation({:*, {_, _, _} = next, int}, value) when is_integer(int) do
    run_equation(next, div(value, int))
  end

  defp run_equation({:-, int, {_, _, _} = next}, value) when is_integer(int) do
    run_equation(next, int - value)
  end

  defp run_equation({:-, {_, _, _} = next, int}, value) when is_integer(int) do
    run_equation(next, value + int)
  end

  defp run_equation({op, :you, v}, value) do
    case op do
      :- -> value + v
    end
  end

  defp nest_ops(reduced, label) when is_binary(label) do
    case Map.fetch!(reduced, label) do
      {:op, {op, left, right}} -> {op, nest_ops(reduced, left), nest_ops(reduced, right)}
      :you -> :you
    end
  end

  defp nest_ops(_, label) when is_integer(label) do
    label
  end

  defp preloop(map, solved) do
    pre = pre_solve(map, solved)

    case pre do
      {^map, solved} -> {map, solved}
      {new, new_solved} -> preloop(new, new_solved)
    end
  end

  defp pre_solve(map, solved) when is_map(map) and is_map(solved) do
    {new_list, solved} =
      Enum.map_reduce(map, solved, fn item, solved ->
        reduce_op(item, solved)
      end)

    {Map.new(new_list), solved}
  end

  defp reduce_op({_, {:val, _}} = keep, solved), do: {keep, solved}
  defp reduce_op({_, :you} = keep, solved), do: {keep, solved}
  defp reduce_op({"root", {:EQUAL, _, _}} = keep, solved), do: {keep, solved}

  defp reduce_op({k, {:op, {op, left, right}}}, solved) do
    left =
      case Map.fetch(solved, left) do
        {:ok, v} -> v
        :error -> left
      end

    right =
      case Map.fetch(solved, right) do
        {:ok, v} -> v
        :error -> right
      end

    if is_integer(left) and is_integer(right) do
      value = calc(op, left, right)
      solved = Map.put(solved, k, value)
      {{k, {:val, value}}, solved}
    else
      {{k, {:op, {op, left, right}}}, solved}
    end
  end
end
