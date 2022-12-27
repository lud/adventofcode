defmodule Aoe.Y22.Day11 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
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

    %{
      id: mid,
      div_by: test_num,
      items: items,
      op: op,
      test: test,
      mtrue: mtrue,
      mfalse: mfalse,
      checked: 0
    }
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
    run(monkeys, fn x -> div(x, 3) end, 20)
  end

  def part_two(monkeys) do
    div_product = Enum.map(monkeys, & &1.div_by) |> Enum.product()

    # f = fn x -> rem(x, div_product) end
    f = fn x -> rem(x, div_product) end
    run(monkeys, f, 10000)
  end

  def run(monkeys, divide, rounds) do
    ids = Enum.map(monkeys, & &1.id)
    map = Enum.reduce(monkeys, %{}, fn monk, acc -> Map.put(acc, monk.id, monk) end)

    monkeys = run_rounds(ids, map, divide, rounds)

    [besta, bestb] =
      monkeys
      |> Enum.map(fn {_, monk} -> monk.checked end)
      |> Enum.sort()
      |> Enum.reverse()
      |> Enum.take(2)

    besta * bestb
  end

  defp run_rounds(_ids, map, _divide, 0) do
    map
  end

  defp run_rounds(ids, map, divide, n) do
    map = run_once(ids, map, divide)
    run_rounds(ids, map, divide, n - 1)
  end

  defp run_once(ids, map, divide) do
    Enum.reduce(ids, map, &run_monk(&1, &2, divide))
  end

  defp run_monk(id, all, divide) do
    monk = Map.fetch!(all, id)
    monk = Map.put(monk, :checked, monk.checked + length(monk.items))
    items = monk.items
    monk = Map.put(monk, :items, [])
    all = Map.put(all, id, monk)
    throws = run_queue(items, monk, divide)
    all = add_thrown(all, throws)
    all
  end

  defp run_queue(items, monk, divide) do
    Enum.map(items, fn level ->
      level = divide.(monk.op.(level))

      if monk.test.(level) do
        {level, monk.mtrue}
      else
        {level, monk.mfalse}
      end
    end)
  end

  defp add_thrown(all, throws) do
    Enum.reduce(throws, all, fn {level, mid}, all ->
      Map.update!(all, mid, fn monk -> Map.update!(monk, :items, &(&1 ++ [level])) end)
    end)
  end
end
