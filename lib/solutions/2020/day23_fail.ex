defmodule AdventOfCode.Y20.Day23Fail do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    input |> String.trim() |> String.to_integer() |> Integer.digits()
  end

  def part_one(cups, moves_amount \\ 100) do
    IO.puts("-- start #{moves_amount} moves --")

    result =
      cups
      |> print_move("INITIAL")
      |> moves(1, moves_amount, Enum.max(cups))
      |> to_answer

    IO.puts("---------------------------------")
    result
  end

  def part_two(cups) do
    moves_amount = 10 * 1000 * 1000
    # moves_amount = 100
    IO.puts("-- start #{moves_amount} moves --")
    # cups = cups ++ [10..1_000_000]
    cups = cups ++ [10..40]

    cups =
      cups
      |> moves(1, moves_amount, 1_000_000)

    IO.puts("---------------------------------")

    [1, a, b | _firsts] = Enum.drop_while(cups, &(&1 != 1))
    result = to_string(a * b)

    result
  end

  defp to_answer(cups) do
    # cycle cups to have the "1" first
    {lasts, [1 | firsts]} = Enum.split_while(cups, &(&1 != 1))

    (firsts ++ lasts)
    |> Enum.map_join("", &to_string/1)

    # |> :erlang.list_to_integer()
  end

  defp moves(cups, n, max_move, _) when n > max_move do
    cups
  end

  defp moves(cups, n, max_move, max_cup) do
    # Process.sleep(1000)

    cups
    |> move(max_cup)
    # |> print_position_of(3)
    |> print_move(n)
    |> moves(n + 1, max_move, max_cup)
  end

  def print_move([_h | _] = cups, n) do
    IO.puts("move #{n}: #{inspect(cups)}")

    # if is_integer(n) do
    #   IO.puts("rem(10, #{h}): #{inspect(rem(10, n))}")
    # end

    cups
  end

  defp move(cups, max_cup) do
    [cur, a, b, c | cups] = unpack(cups, 4)
    dest = to_dest(cur - 1, [a, b, c], max_cup)
    _cups = rearrange(cups, dest, {a, b, c}, cur)
  end

  def to_dest(0, ignore, max_cup), do: to_dest(max_cup, ignore, max_cup)

  def to_dest(cur, [a, b, c] = ignore, max_cup) when cur in [a, b, c],
    do: to_dest(cur - 1, ignore, max_cup)

  def to_dest(cur, [_a, _b, _c], _max_cup), do: cur

  defp unpack(cups, 0) do
    cups
  end

  defp unpack([rbeg..rend | cups], amount) when rbeg == rend do
    unpack([rbeg | cups], amount)
  end

  defp unpack([rbeg..rend | cups], amount) do
    [rbeg | unpack([range_or_num(rbeg + 1, rend)] ++ cups, amount - 1)]
  end

  defp unpack([cur | cups], amount) when is_integer(cur) do
    [cur | unpack(cups, amount - 1)]
  end

  # defp find_destination(0, _, pool), do: Enum.max(pool)

  # defp find_destination(cur, [rbeg..rend | cups], pool) when cur - 1 >= rbeg and cur - 1 <= rend,
  #   do: cur - 1

  # defp find_destination(cur, [c | cups], pool) when c == cur - 1, do: c
  # defp find_destination(cur, [_ | cups], pool), do: find_destination(cur, cups, pool)
  # defp find_destination(cur, [], pool), do: find_destination(cur - 1, pool, pool)

  defp rearrange([rbeg..rend | cups], dest, {a, b, c}, last) when dest >= rbeg and dest <= rend do
    insert_in_range(rbeg, rend, dest, [a, b, c]) ++ put_last(cups, last)
  end

  defp rearrange([dest | cups], dest, {a, b, c}, last) do
    [dest, a, b, c | put_last(cups, last)]
  end

  defp rearrange([c | cups], dest, pickups, last) do
    [c | rearrange(cups, dest, pickups, last)]
  end

  defp insert_in_range(n, n, n, insert) do
    [n] ++ insert
  end

  defp insert_in_range(n, rend, n, insert) do
    [n] ++ insert ++ [range_or_num(n + 1, rend)]
  end

  defp insert_in_range(rbeg, n, n, insert) do
    [range_or_num(rbeg, n - 1)] ++ insert ++ [n]
  end

  defp insert_in_range(rbeg, rend, n, insert) do
    [range_or_num(rbeg, n - 1), n] ++ insert ++ [range_or_num(n + 1, rend)]
  end

  defp range_or_num(n, n) do
    n
  end

  defp range_or_num(rbeg, rend) when rend > rbeg do
    rbeg..rend
  end

  defp put_last([], cup) do
    [cup]
  end

  defp put_last([c | cups], cup) do
    [c | put_last(cups, cup)]
  end
end
