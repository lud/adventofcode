defmodule AdventOfCode.Solutions.Y24.Day17 do
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
        # print(instr,arg)
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

    value = div(numerator, divisor)
    state = putv(state, dest, value)
    {:next, state}
  end

  defp get_combo(_state, {_, {:lit, v}}), do: v
  defp get_combo(%{a: a}, {_, {:reg, :a}}), do: a
  defp get_combo(%{b: b}, {_, {:reg, :b}}), do: b
  defp get_combo(%{c: c}, {_, {:reg, :c}}), do: c

  def get_lit({v, _}), do: v

  defp putv(state, :a, v) do
    # IO.puts("UPDATE A !!!!! #{state.a} => #{v}")
    %{state | a: v}
  end

  defp putv(state, reg, v) when reg in [:a, :b, :c], do: %{state | reg => v}

  defp output(state, value), do: %{state | stdout: [value | state.stdout]}

  def part_two(vm) do

    # This may only work with my program...
    #
    #     B = A mod 8
    #     B = B xor 3
    #     C = A / 2 ** B
    #     B = B xor 5
    #     A = A / 2 ** 3
    #     B = B xor C
    #     puts B mod 8
    #     if A != 0 then jump 0
    #
    # Starting from the end we can see that the only update to A is:
    #
    #     A = A / 2 ** 3      # 2 ** 3 = 8
    #
    # But as we are working with modulos (first line of fprogram starts with B =
    # A mod 8), we need to consider all possible inputs between N and N+7 for a
    # digit.
    #
    # We use the reversed output and iterate this way:
    #
    # * Start with possible inputs between 0 and 7, and index = 0 (index targets
    #   the reversed expected output)
    # * For each possible input, feed the program with that in the A registry,
    #   and check that the output is the one exepected at `index`.
    # * Keep only those values of A where the output was the expected one.
    # * For each of those values, expand them to the possible modulo, so N
    #   becomes N..(N+7).
    # * That new list is the possible inputs for the next iteration, where we
    #   will now look the output at index=1.
    # * Loop over and over. The last loop is when index == number of digits - 1.
    # * After the last loop the possible inputs list (96 numbers in my case)
    #   contains the correct response.
    # * There is probably a solution for that but since it's a small list we can
    #   just run the program for each one until we find the solution.

    expected =
      vm.raw
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> :lists.reverse()

    targets = Map.new(Enum.with_index(expected), fn {d, i} -> {i, d} end)

    digit_count = length(expected)

    base_state =
      vm
      |> Map.take([:a, :b, :c])
      |> Map.put(:stdout, [])

    call = fn a ->
      state = Map.put(base_state, :a, a)
      %{stdout: stdout} = run(vm.program, state, 0)
      stdout
    end

    possible_inputs = loop_find([0, 1, 2, 3, 4, 5, 6, 7], _index = 0, digit_count - 1, targets, call)

    Enum.find(possible_inputs, fn a -> call.(a) == expected end)
  end

  defp loop_find(inputs, index, max_pow, targets, call) when index < max_pow do
    target = Map.fetch!(targets, index)

    next_inputs =
      inputs
      |> Enum.filter(fn a ->
        stdout = call.(a)
        Enum.at(stdout, index) == target
      end)
      |> Enum.flat_map(fn a ->
        next = a * 8
        range = next..(next + 7)
        Enum.filter(range, &(div(&1, 8) == a))
      end)

    loop_find(next_inputs, index + 1, max_pow, targets, call)
  end

  defp loop_find(inputs, _index, _max_pow, _targets, _call) do
    inputs
  end


  # Unused but helpful !

  def print_program(vm) do
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
    IO.puts("B = B xor #{print_lit(arg)}")
  end

  # 2
  defp print(:bst, arg) do
    IO.puts("B = #{print_combo(arg)} mod 8")
  end

  # 3
  defp print(:jnz, arg) do
    IO.puts("if A != 0 then jump #{print_lit(arg)}")
  end

  # 4
  defp print(:bxc, _arg) do
    IO.puts("B = B xor C")
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
