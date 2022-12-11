defmodule Aoe.Y22.Day11 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_monkey/1)
  end

  defp parse_monkey(block) do
    #   Monkey 0:
    # Starting items: 79, 98
    # Operation: new = old * 19
    # Test: divisible by 23
    #   If true: throw to monkey 2
    #   If false: throw to monkey 3
    [
      "Monkey " <> raw_mid,
      "Starting items: " <> raw_list,
      "Operation: new = " <> raw_op,
      "Test: divisible by " <> raw_test,
      "If true: throw to monkey " <> raw_iftrue,
      "If false: throw to monkey " <> raw_iffalse
    ] = block |> String.split("\n") |> Enum.map(&String.trim/1)

    {mid, ":"} = Integer.parse(raw_mid)
    items = raw_list |> String.split(", ") |> Enum.map(&String.to_integer/1)
    op = parse_op(raw_op)
    test_num = String.to_integer(raw_test)
    test = fn x -> rem(x, test_num) === 0 end
    mtrue = String.to_integer(raw_iftrue)
    mfalse = String.to_integer(raw_iffalse)

    %{id: mid, items: items, op: op, test: test, mtrue: mtrue, mfalse: mfalse, inspects: 0}
  end

  defp parse_op("old * old"), do: fn x -> x * x end
  # defp parse_op("old + old"), do: fn x -> x + x end
  defp parse_op("old * " <> sn) do
    n = String.to_integer(sn)
    fn x -> x * n end
  end

  defp parse_op("old + " <> sn) do
    n = String.to_integer(sn)
    fn x -> x + n end
  end

  def part_one(monkeys) do
    ids = Enum.map(monkeys, & &1.id)
    map = Enum.reduce(monkeys, %{}, fn monk, acc -> Map.put(acc, monk.id, monk) end)
    ids |> IO.inspect(label: "ids")
    map |> IO.inspect(label: "map")

    monkeys = run_rounds(ids, map, 20)

    [besta, bestb] =
      monkeys
      |> Enum.map(fn {_, monk} -> monk.inspects end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(2)

    besta * bestb
  end

  defp run_rounds(ids, map, 0) do
    map
  end

  defp run_rounds(ids, map, n) do
    map = run_once(ids, map)
    run_rounds(ids, map, n - 1)
  end

  defp run_once(ids, map) do
    Enum.reduce(ids, map, &run_monk/2)
  end

  defp run_monk(id, all) do
    monk = Map.fetch!(all, id)
    monk = Map.put(monk, :inspects, monk.inspects + length(monk.items))
    items = monk.items
    monk = Map.put(monk, :items, [])
    all = Map.put(all, id, monk)
    throws = run_queue(items, monk)
    all = add_thrown(all, throws)
    all
  end

  defp run_queue(items, monk) do
    Enum.map(items, fn level ->
      level = div(monk.op.(level), 3)

      if monk.test.(level) do
        {level, monk.mtrue}
      else
        {level, monk.mfalse}
      end
    end)
    |> IO.inspect(label: "throws")
  end

  defp add_thrown(all, throws) do
    Enum.reduce(throws, all, fn {level, mid}, all ->
      Map.update!(all, mid, fn monk -> Map.update!(monk, :items, &(&1 ++ [level])) end)
    end)
  end

  def part_two(problem) do
    problem
  end
end
