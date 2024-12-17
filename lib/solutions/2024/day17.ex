defmodule AdventOfCode.Solutions.Y24.Day17 do
  alias AdventOfCode.BinarySearch
  alias AoC.Input

  def parse(input, _part) do
    input
    |> Input.stream!(trim: true)
    |> Enum.flat_map(fn
      "Register A: " <> str_a -> [{:a, String.to_integer(str_a)}]
      "Register B: " <> str_b -> [{:b, String.to_integer(str_b)}]
      "Register C: " <> str_c -> [{:c, String.to_integer(str_c)}]
      "Program: " <> str_ints -> [{:program, parse_program(str_ints)}, {:raw, str_ints}]
    end)
    |> Map.new()
  end

  def parse_program(str_ints) do
    pairs =
      str_ints
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(&parse_instruction/1)

    indexes = Stream.iterate(0, &(&1 + 2))

    Map.new(Enum.zip(indexes, pairs))
  end

  defp parse_instruction([opcode, operand]) do
    {opcode(opcode), {operand, to_combo(operand)}}
  end

  defp opcode(0), do: :adv
  defp opcode(1), do: :bxl
  defp opcode(2), do: :bst
  defp opcode(3), do: :jnz
  defp opcode(4), do: :bxc
  defp opcode(5), do: :out
  defp opcode(6), do: :bdv
  defp opcode(7), do: :cdv

  defp to_combo(0), do: {:lit, 0}
  defp to_combo(1), do: {:lit, 1}
  defp to_combo(2), do: {:lit, 2}
  defp to_combo(3), do: {:lit, 3}
  defp to_combo(4), do: {:reg, :a}
  defp to_combo(5), do: {:reg, :b}
  defp to_combo(6), do: {:reg, :c}
  defp to_combo(7), do: :invalid

  def part_one(vm) do
    state =
      vm
      |> Map.take([:a, :b, :c])
      |> Map.put(:stdout, [])

    %{stdout: out} = run(vm.program, state, 0)

    out
    |> :lists.reverse()
    |> Enum.map_join(",", &Integer.to_string/1)
  end

  def run(prog, state, pos) do
    case run_once(prog, state, pos) do
      :halt -> state
      {state, pos} -> run(prog, state, pos)
    end
  end

  def run_once(prog, state, pos) do
    case Map.fetch(prog, pos) do
      :error ->
        # IO.puts("no index #{inspect(pos)}")
        :halt

      {:ok, {instr, arg}} ->
        # IO.puts("EXEC #{inspect(instr)} #{inspect(arg)}")

        result =
          case exec(instr, arg, state) do
            {:next, state} -> {state, pos + 2}
            {:jump, next_pos, state} -> {state, next_pos}
          end

        # IO.puts("  => #{inspect(result)}")
        result
    end
  end

  # 0
  defp exec(:adv, arg, state) do
    dv(:a, arg, state)
  end

  # 1
  defp exec(:bxl, arg, state) do
    value = Bitwise.bxor(state.b, get_lit(arg))
    {:next, putv(state, :b, value)}
  end

  # 2
  defp exec(:bst, arg, state) do
    value = get_combo(state, arg) |> Integer.mod(8)
    {:next, putv(state, :b, value)}
  end

  # 3
  defp exec(:jnz, arg, state) do
    case state.a do
      0 -> {:next, state}
      _ -> {:jump, get_lit(arg), state}
    end
  end

  # 4
  defp exec(:bxc, _arg, state) do
    value = Bitwise.bxor(state.b, state.c)
    {:next, putv(state, :b, value)}
  end

  # 5
  defp exec(:out, arg, state) do
    value = Integer.mod(get_combo(state, arg), 8)
    {:next, output(state, value)}
  end

  # 6
  defp exec(:bdv, arg, state) do
    dv(:b, arg, state)
  end

  # 7
  defp exec(:cdv, arg, state) do
    dv(:c, arg, state)
  end

  defp dv(dest, arg, state) do
    numerator = state.a
    divisor = 2 ** get_combo(state, arg)
    dbg(numerator / divisor)
    value = div(numerator, divisor) |> dbg()
    state = putv(state, dest, value)
    {:next, state}
  end

  defp get_combo(_state, {_, {:lit, v}}), do: v
  defp get_combo(%{a: a}, {_, {:reg, :a}}), do: a
  defp get_combo(%{b: b}, {_, {:reg, :b}}), do: b
  defp get_combo(%{c: c}, {_, {:reg, :c}}), do: c

  def get_lit({v, _}), do: v

  defp putv(state, reg, v) when reg in [:a, :b, :c], do: %{state | reg => v}

  defp output(state, value), do: %{state | stdout: [value | state.stdout]}

  def part_two(vm) do
    part_one(vm)
    print_program(vm)
    #   expected =
    #     vm.raw
    #     |> String.split(",")
    #     |> Enum.map(&String.to_integer/1)
    #     |> :lists.reverse()
    #     |> dbg()

    #   digit_count = length(expected)
    #   digit_count |> IO.inspect(label: "digit_count")

    #   #   [0 | target] = expected |> dbg()
    #   #   target |> dbg()
    #   #   t = Integer.undigits(target, 8) |> dbg()
    #   #   (t * 8) |> dbg()

    #   # I found that for a number in base 8, changing the nth digit of that number
    #   # changes the nths digit of the (reverse) output. But not in order so we
    #   # have to find what input digit outputs the right one.

    #   base_state =
    #     vm
    #     |> Map.take([:a, :b, :c])
    #     |> Map.put(:stdout, [])

    #   base_a = 8 ** (digit_count - 1)
    #   base_a |> dbg()
    #   IO.puts("base: 0o#{Integer.to_string(base_a, 8)}")

    #   #   base

    #   # Enum.map(0..(digit_count - 1), fn index ->
    #   #   target_digit = Enum.at(expected, index) |> dbg()
    #   #   inputs =

    #   # end)

    #   # expected |> Enum.map(&Map.fetch!(mapping, &1)) |> dbg()

    #   empty_input = List.duplicate("1", digit_count)

    #   # Enum.map(0..(digit_count - 1), fn index ->
    #   #   IO.puts("======== index #{index}")
    #   #   expected_digit = Enum.at(expected, index)
    #   #   expected_digit |> IO.inspect(label: "expected_digit")
    #   #   inputs = Enum.map(0..7, &{&1, List.replace_at(empty_input, index, Integer.to_string(&1))})

    #   #   Enum.find_value(inputs, fn {digit, input} ->
    #   #     IO.puts("------ digit #{digit} ")
    #   #     ^digit_count = length(input)
    #   #     {a, ""} = input |> Enum.join("") |> Integer.parse(8)
    #   #     IO.puts("b8: " <> String.pad_leading(Integer.to_string(a, 8), digit_count, "0"))

    #   #     state = Map.put(base_state, :a, a)

    #   #     %{stdout: stdout} = run(vm.program, state, 0)
    #   #     input |> IO.inspect(label: "input")
    #   #     stdout |> IO.inspect(label: "stdout")

    #   #     # if index == 0 && digit_count != length(stdout) do
    #   #     #   {0, 0}
    #   #     # else
    #   #     if Enum.at(stdout, index) == expected_digit do
    #   #       {index, digit}
    #   #     else
    #   #       false
    #   #     end

    #   #     # end
    #   #   end)
    #   # end)
    #   # |> dbg()

    #   # Enum.reduce((digit_count - 1)..0//-1, [], fn index, prev ->
    #   #   IO.puts("======== index #{index}")
    #   #   expected_digit = Enum.at(expected, index)
    #   #   expected_digit |> IO.inspect(label: "expected_digit")
    #   #   inputs = Enum.map(0..7, &{&1, [&1 | prev]})

    #   #   Enum.find_value(inputs, fn {digit, input} ->
    #   #     IO.puts("------ digit #{digit} ")
    #   #     # ^digit_count = length(input)
    #   #     {a, ""} = input |> Enum.join("") |> Integer.parse(8)
    #   #     IO.puts("b8: " <> String.pad_leading(Integer.to_string(a, 8), digit_count, "0"))

    #   #     state = Map.put(base_state, :a, a)

    #   #     %{stdout: stdout} = run(vm.program, state, 0)
    #   #     input |> IO.inspect(label: "input")
    #   #     stdout |> IO.inspect(label: "stdout")

    #   #     # if index == 0 && digit_count != length(stdout) do
    #   #     #   {0, 0}
    #   #     # else
    #   #     case stdout do
    #   #       [^expected_digit | _] -> {index, digit}
    #   #       _ -> nil
    #   #     end

    #   #     # end
    #   #   end)

    #   #   # |> case do
    #   #   #   {index, digit} -> {{index, digit}, [digit | prev]}
    #   #   # end
    #   # end)
    #   # |> dbg()

    #   # # Find the number of digits.
    #   # # It's totally useless as it is the number
    #   # pow =
    #   #   BinarySearch.search(fn pow ->
    #   #     a = 8 ** pow
    #   #     state = Map.put(base_state, :a, 8 ** pow)

    #   #     result = run(vm.program, state, 0) |> dbg()
    #   #     a |> IO.inspect(label: "a")
    #   #     len = length(result.stdout)

    #   #     cond do
    #   #       len > digit_count -> :gt
    #   #       len < digit_count -> :lt
    #   #       len == digit_count -> :eq
    #   #     end
    #   #   end)

    #   # num_digits = pow + 1

    #   #     # Stream.iterate(0, &(&1 + 1))

    #   [
    #     # 0o0,
    #     # 0o1,
    #     # 0o2,
    #     # 0o3,
    #     # 0o4,
    #     # 0o5,
    #     # 0o6,
    #     # #
    #     # 0o7,
    #     # 0o10,
    #     # 0o11,
    #     # 0o12,
    #     # 0o13,
    #     # 0o14,
    #     # 0o15,
    #     # 0o16,
    #     # #
    #     # 0o17,
    #     # 0o20,
    #     # 0o21,
    #     # 0o22,
    #     # 0o23,
    #     # 0o24,
    #     # 0o25,
    #     # 0o26,
    #     # 0o27

    #     0,
    #     1,
    #     2,
    #     3,
    #     4,
    #     5,
    #     6,
    #     7,
    #     0o10,
    #     0o11,
    #     0o12,
    #     0o13,
    #     0o14,
    #     0o15,
    #     0o16,
    #     0o17,
    #     0o20,
    #     0o21,
    #     0o22,
    #     0o23,
    #     0o24,
    #     0o25,
    #     0o26,
    #     0o27
    #   ]
    #   # base_a..(base_a + 10)
    #   |> Stream.filter(fn
    #     :sep ->
    #       IO.puts("----")
    #       false

    #     _ ->
    #       true
    #   end)
    #   |> Stream.each(&IO.puts("b8: " <> Integer.to_string(&1, 8)))
    #   |> Stream.map(fn a ->
    #     state = Map.put(base_state, :a, a)
    #     a |> IO.inspect(label: "a")

    #     result = run(vm.program, state, 0)
    #     result.stdout |> IO.inspect(label: "result.stdout")

    #     if result.stdout == expected do
    #       throw({:found, a})
    #     end
    #   end)
    #   |> Stream.run()

    #   expected |> IO.inspect(label: "expected")
    #   :not_found
    # catch
    #   {:found, a} -> a
  end

  defp print_program(vm) do
    %{program: program} = vm

    program
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.each(&print/1)
  end

  defp print({tag, arg}) do
    print(tag, arg)
  end

  # 0
  defp print(:adv, arg) do
    IO.puts("A = A / 2 ** #{print_combo(arg)}")
  end

  # 1
  defp print(:bxl, arg) do
    IO.puts "B = B xor #{print_lit(arg)}"

  end

  # 2
  defp print(:bst, arg) do
    IO.puts "B = #{print_combo(arg)} mod 8"
  end

  # 3
  defp print(:jnz, arg) do
    IO.puts("if A != 0 then jump #{print_lit(arg)}")
  end

  # 4
  defp print(:bxc, _arg) do
    IO.puts "B = B xor C"
  end

  # 5
  defp print(:out, arg) do
    IO.puts("puts #{print_combo(arg)} mod 8")
  end

  # 6
  defp print(:bdv, arg) do
    IO.puts("B = A / 2 ** #{print_combo(arg)}")
  end

  # 7
  defp print(:cdv, arg) do
    IO.puts("C = A / 2 ** #{print_combo(arg)}")
  end

  defp print_combo({_, {:lit, n}}), do: Integer.to_string(n)
  defp print_combo({_, {:reg, :a}}), do: "A"
  defp print_combo({_, {:reg, :b}}), do: "B"
  defp print_combo({_, {:reg, :C}}), do: "C"
  defp print_lit({n, _}), do: Integer.to_string(n)
end
