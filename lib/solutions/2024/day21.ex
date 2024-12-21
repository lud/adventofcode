defmodule AdventOfCode.Solutions.Y24.Day21.Generator do
  alias AdventOfCode.Grid
  alias AdventOfCode.PathFinder.Multi

  def output do
    output_digits()
    output_directionals()
  end

  def output_digits do
    digit_grid = make_digit_grid()
    digit_to_coord = Map.new(digit_grid, fn {k, v} -> {v, k} end)

    for start <- digits(), target <- digits(), start != target do
      start_state = Map.fetch!(digit_to_coord, start)
      target_pos = Map.fetch!(digit_to_coord, target)

      {bests, costs} =
        Multi.best_paths(digit_grid, start_state, target_pos, fn
          :neighbors, pos, ^digit_grid ->
            Grid.cardinal4(pos)
            |> Enum.filter(&Map.has_key?(digit_grid, &1))
            |> Enum.map(&{&1, 1})

          :target?, pos, ^target_pos ->
            pos == target_pos

          :target?, pos, other ->
            raise "target_pos is #{inspect(target_pos)}but was given #{inspect(other)}"
        end)

      [{^target_pos, _}] = bests

      path = rebuild_path(target_pos, costs, [])

      directions =
        Enum.reduce(tl(path), {hd(path), []}, fn next, {prev, dirs} ->
          direction = Grid.which_direction(prev, next)
          {next, [direction | dirs]}
        end)
        |> elem(1)
        |> Enum.map(fn
          :n -> :^
          :w -> :<
          :s -> :v
          :e -> :>
        end)
        # sort the digits descending, so we will always move up and right before
        # attempting to move down or left which could cause to go over the empty
        # space.
        # Also group same moves together
        |> Enum.sort_by(
          if start in [0, :A] or target in [0, :A] do
            fn
              :> -> 0
              :^ -> 1
              :< -> 1000
              :v -> 1001
            end
          else
            fn
              :> -> 0
              :^ -> 1
              :< -> -1
              :v -> 1001
            end
          end
        )
        |> Kernel.++([:A])

      IO.puts("defp digit_press_seq(#{inspect(start)}, #{inspect(target)}),do: #{inspect(directions)}")
    end
  end

  def output_directionals do
    directional_grid = make_directional_grid()
    directional_to_coord = Map.new(directional_grid, fn {k, v} -> {v, k} end)

    for start <- directionals(), target <- directionals(), start != target do
      start_state = Map.fetch!(directional_to_coord, start)
      target_pos = Map.fetch!(directional_to_coord, target)

      {bests, costs} =
        Multi.best_paths(directional_grid, start_state, target_pos, fn
          :neighbors, pos, ^directional_grid ->
            Grid.cardinal4(pos)
            |> Enum.filter(&Map.has_key?(directional_grid, &1))
            |> Enum.map(&{&1, 1})

          :target?, pos, ^target_pos ->
            pos == target_pos

          :target?, pos, other ->
            raise "target_pos is #{inspect(target_pos)}but was given #{inspect(other)}"
        end)

      [{^target_pos, _}] = bests

      path = rebuild_path(target_pos, costs, [])

      directions =
        Enum.reduce(tl(path), {hd(path), []}, fn next, {prev, dirs} ->
          direction = Grid.which_direction(prev, next)
          {next, [direction | dirs]}
        end)
        |> elem(1)
        |> Enum.map(fn
          :n -> :^
          :w -> :<
          :s -> :v
          :e -> :>
        end)
        # Unlink to the numeric keypad, here we prioritize going down and right
        # (instead of up and right)

        |> Enum.sort_by(fn
          :> -> 0
          :^ -> 1001
          :< -> 1000
          :v -> 1
        end)
        |> Kernel.++([:A])

      IO.puts("defp directional_press_seq(#{inspect(start)}, #{inspect(target)}),do: #{inspect(directions)}")
    end
  end

  def rebuild_path(next_pos, costs, acc) do
    case Map.fetch!(costs, next_pos) do
      [{:"$path_start", _}] -> [next_pos | acc]
      [{pos, _} | _] -> rebuild_path(pos, costs, [next_pos | acc])
    end
  end

  def make_digit_grid do
    {digit_grid, _, _} =
      """
      789
      456
      123
       0A
      """
      |> String.split("\n", trim: true)
      |> Grid.parse_lines(fn
        c when c in ?0..?9 -> {:ok, c - ?0}
        ?A -> {:ok, :A}
        ?\s -> :ignore
      end)

    digit_grid
  end

  def make_directional_grid do
    {directional_grid, _, _} =
      """
       ^A
      <v>
      """
      |> String.split("\n", trim: true)
      |> Grid.parse_lines(fn
        ?^ -> {:ok, :^}
        ?< -> {:ok, :<}
        ?v -> {:ok, :v}
        ?> -> {:ok, :>}
        ?A -> {:ok, :A}
        ?\s -> :ignore
      end)

    directional_grid
  end

  def digits do
    Enum.concat(0..9, [:A])
  end

  def directionals do
    [:>, :^, :<, :v, :A]
  end
end

AdventOfCode.Solutions.Y24.Day21.Generator.output()

defmodule AdventOfCode.Solutions.Y24.Day21 do
  alias AoC.Input

  def parse(input, _part) do
    input |> Input.stream!(trim: true) |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(fn
      "A" -> :A
      n -> String.to_integer(n)
    end)
  end

  def part_one(door_codes) do
    door_codes
    |> Enum.map(fn code ->
      seq = compute_sequences(code)
      len = length(seq)
      num_part = code |> Enum.filter(&(&1 in 0..9)) |> Integer.undigits()
      IO.puts("#{inspect(code)}: #{len} * #{num_part}")
      num_part * len
    end)
    |> Enum.sum()
  end

  defp compute_sequences(robot1_code) do
    Enum.reduce(robot1_code, {:A, []}, fn digit, {prev_pos, acc} ->
      IO.puts("--------------")
      IO.puts("starting from #{prev_pos}")
      IO.puts("go to press #{digit}")
      robot2_dirs = digit_press_seq(prev_pos, digit) |> printseq()
      robot3_dirs = directional_to_directional(robot2_dirs) |> printseq()
      your_dirs = directional_to_directional(robot3_dirs) |> printseq()
      {digit, [your_dirs | acc]}
    end)
    |> elem(1)
    |> :lists.flatten()

    # IO.puts("3 to 7")
    # IO.puts("=================== good")
    # good = [:<, :^, :A] |> printseq()
    # debug_sequences(good)
    # # good2 = directional_to_directional(good) |> printseq()
    # # good3 = directional_to_directional(good2) |> printseq()
    # IO.puts("=================== bad")
    # bad = [:^, :<, :A] |> printseq()
    # debug_sequences(bad)
    # # bad2 = directional_to_directional(bad) |> printseq()
    # # bad3 = directional_to_directional(bad2) |> printseq()

    #   print_group_sequences([
    #     robot1_code,
    #     robot2_dirs,
    #   robot3_dirs,
    #   your_dirs
    # ])
    # |> dbg()

    # your_dirs
  end

  defp debug_sequences(robot2) do
    Enum.reduce(robot2, {:A, []}, fn digit, {prev_pos, acc} ->
      IO.puts("--------------")
      IO.puts("starting from #{prev_pos}")
      IO.puts("go to press #{digit}")

      robot3_dirs = directional_press_seq(prev_pos, digit) |> printseq()
      your_dirs = directional_to_directional(robot3_dirs) |> printseq()
      {digit, [your_dirs | acc]}
    end)
    |> elem(1)
    |> :lists.flatten()

    #   print_group_sequences([
    #     robot1_code,
    #     robot2_dirs,
    #   robot3_dirs,
    #   your_dirs
    # ])
    # |> dbg()

    # your_dirs
  end

  defp print_group_sequences(sequences) do
    sequences
    |> Enum.map(&chunks_ending_with_a(&1))
    |> Enum.zip()
    |> dbg()
  end

  def chunks_ending_with_a(seq) do
    Enum.chunk_while(
      seq,
      [],
      fn
        :A, acc -> {:cont, :lists.reverse(acc, [:A]), []}
        n, acc -> {:cont, [n | acc]}
      end,
      fn [] -> {:cont, []} end
    )
  end

  defp numeric_to_directional(keys) do
    keys
    |> Enum.reduce({_start_pos = :A, []}, fn key, {prev_pos, seqs} ->
      {key, [seqs, digit_press_seq(prev_pos, key)]}
    end)
    |> elem(1)
    |> :lists.flatten()
  end

  defp directional_to_directional(keys) do
    keys
    |> Enum.reduce({_start_pos = :A, []}, fn key, {prev_pos, seqs} ->
      {key, [seqs, directional_press_seq(prev_pos, key)]}
    end)
    |> elem(1)
    |> :lists.flatten()
  end

  defp printseq(seq) do
    seq
    |> chunks_ending_with_a()
    |> Enum.intersperse(" ")
    |> :lists.flatten()
    |> Enum.map(&to_string/1)
    |> IO.puts()

    seq
  end

  defp digit_press_seq(0, 1), do: [:^, :<, :A]
  defp digit_press_seq(0, 2), do: [:^, :A]
  defp digit_press_seq(0, 3), do: [:>, :^, :A]
  defp digit_press_seq(0, 4), do: [:^, :^, :<, :A]
  defp digit_press_seq(0, 5), do: [:^, :^, :A]
  defp digit_press_seq(0, 6), do: [:>, :^, :^, :A]
  defp digit_press_seq(0, 7), do: [:^, :^, :^, :<, :A]
  defp digit_press_seq(0, 8), do: [:^, :^, :^, :A]
  defp digit_press_seq(0, 9), do: [:>, :^, :^, :^, :A]
  defp digit_press_seq(0, :A), do: [:>, :A]
  defp digit_press_seq(1, 0), do: [:>, :v, :A]
  defp digit_press_seq(1, 2), do: [:>, :A]
  defp digit_press_seq(1, 3), do: [:>, :>, :A]
  defp digit_press_seq(1, 4), do: [:^, :A]
  defp digit_press_seq(1, 5), do: [:>, :^, :A]
  defp digit_press_seq(1, 6), do: [:>, :>, :^, :A]
  defp digit_press_seq(1, 7), do: [:^, :^, :A]
  defp digit_press_seq(1, 8), do: [:>, :^, :^, :A]
  defp digit_press_seq(1, 9), do: [:>, :>, :^, :^, :A]
  defp digit_press_seq(1, :A), do: [:>, :>, :v, :A]
  defp digit_press_seq(2, 0), do: [:v, :A]
  defp digit_press_seq(2, 1), do: [:<, :A]
  defp digit_press_seq(2, 3), do: [:>, :A]
  defp digit_press_seq(2, 4), do: [:<, :^, :A]
  defp digit_press_seq(2, 5), do: [:^, :A]
  defp digit_press_seq(2, 6), do: [:>, :^, :A]
  defp digit_press_seq(2, 7), do: [:<, :^, :^, :A]
  defp digit_press_seq(2, 8), do: [:^, :^, :A]
  defp digit_press_seq(2, 9), do: [:>, :^, :^, :A]
  defp digit_press_seq(2, :A), do: [:>, :v, :A]
  defp digit_press_seq(3, 0), do: [:<, :v, :A]
  defp digit_press_seq(3, 1), do: [:<, :<, :A]
  defp digit_press_seq(3, 2), do: [:<, :A]
  defp digit_press_seq(3, 4), do: [:<, :<, :^, :A]
  defp digit_press_seq(3, 5), do: [:<, :^, :A]
  defp digit_press_seq(3, 6), do: [:^, :A]
  defp digit_press_seq(3, 7), do: [:<, :<, :^, :^, :A]
  defp digit_press_seq(3, 8), do: [:<, :^, :^, :A]
  defp digit_press_seq(3, 9), do: [:^, :^, :A]
  defp digit_press_seq(3, :A), do: [:v, :A]
  defp digit_press_seq(4, 0), do: [:>, :v, :v, :A]
  defp digit_press_seq(4, 1), do: [:v, :A]
  defp digit_press_seq(4, 2), do: [:>, :v, :A]
  defp digit_press_seq(4, 3), do: [:>, :>, :v, :A]
  defp digit_press_seq(4, 5), do: [:>, :A]
  defp digit_press_seq(4, 6), do: [:>, :>, :A]
  defp digit_press_seq(4, 7), do: [:^, :A]
  defp digit_press_seq(4, 8), do: [:>, :^, :A]
  defp digit_press_seq(4, 9), do: [:>, :>, :^, :A]
  defp digit_press_seq(4, :A), do: [:>, :>, :v, :v, :A]
  defp digit_press_seq(5, 0), do: [:v, :v, :A]
  defp digit_press_seq(5, 1), do: [:<, :v, :A]
  defp digit_press_seq(5, 2), do: [:v, :A]
  defp digit_press_seq(5, 3), do: [:>, :v, :A]
  defp digit_press_seq(5, 4), do: [:<, :A]
  defp digit_press_seq(5, 6), do: [:>, :A]
  defp digit_press_seq(5, 7), do: [:<, :^, :A]
  defp digit_press_seq(5, 8), do: [:^, :A]
  defp digit_press_seq(5, 9), do: [:>, :^, :A]
  defp digit_press_seq(5, :A), do: [:>, :v, :v, :A]
  defp digit_press_seq(6, 0), do: [:<, :v, :v, :A]
  defp digit_press_seq(6, 1), do: [:<, :<, :v, :A]
  defp digit_press_seq(6, 2), do: [:<, :v, :A]
  defp digit_press_seq(6, 3), do: [:v, :A]
  defp digit_press_seq(6, 4), do: [:<, :<, :A]
  defp digit_press_seq(6, 5), do: [:<, :A]
  defp digit_press_seq(6, 7), do: [:<, :<, :^, :A]
  defp digit_press_seq(6, 8), do: [:<, :^, :A]
  defp digit_press_seq(6, 9), do: [:^, :A]
  defp digit_press_seq(6, :A), do: [:v, :v, :A]
  defp digit_press_seq(7, 0), do: [:>, :v, :v, :v, :A]
  defp digit_press_seq(7, 1), do: [:v, :v, :A]
  defp digit_press_seq(7, 2), do: [:>, :v, :v, :A]
  defp digit_press_seq(7, 3), do: [:>, :>, :v, :v, :A]
  defp digit_press_seq(7, 4), do: [:v, :A]
  defp digit_press_seq(7, 5), do: [:>, :v, :A]
  defp digit_press_seq(7, 6), do: [:>, :>, :v, :A]
  defp digit_press_seq(7, 8), do: [:>, :A]
  defp digit_press_seq(7, 9), do: [:>, :>, :A]
  defp digit_press_seq(7, :A), do: [:>, :>, :v, :v, :v, :A]
  defp digit_press_seq(8, 0), do: [:v, :v, :v, :A]
  defp digit_press_seq(8, 1), do: [:<, :v, :v, :A]
  defp digit_press_seq(8, 2), do: [:v, :v, :A]
  defp digit_press_seq(8, 3), do: [:>, :v, :v, :A]
  defp digit_press_seq(8, 4), do: [:<, :v, :A]
  defp digit_press_seq(8, 5), do: [:v, :A]
  defp digit_press_seq(8, 6), do: [:>, :v, :A]
  defp digit_press_seq(8, 7), do: [:<, :A]
  defp digit_press_seq(8, 9), do: [:>, :A]
  defp digit_press_seq(8, :A), do: [:>, :v, :v, :v, :A]
  defp digit_press_seq(9, 0), do: [:<, :v, :v, :v, :A]
  defp digit_press_seq(9, 1), do: [:<, :<, :v, :v, :A]
  defp digit_press_seq(9, 2), do: [:<, :v, :v, :A]
  defp digit_press_seq(9, 3), do: [:v, :v, :A]
  defp digit_press_seq(9, 4), do: [:<, :<, :v, :A]
  defp digit_press_seq(9, 5), do: [:<, :v, :A]
  defp digit_press_seq(9, 6), do: [:v, :A]
  defp digit_press_seq(9, 7), do: [:<, :<, :A]
  defp digit_press_seq(9, 8), do: [:<, :A]
  defp digit_press_seq(9, :A), do: [:v, :v, :v, :A]
  defp digit_press_seq(:A, 0), do: [:<, :A]
  defp digit_press_seq(:A, 1), do: [:^, :<, :<, :A]
  defp digit_press_seq(:A, 2), do: [:^, :<, :A]
  defp digit_press_seq(:A, 3), do: [:^, :A]
  defp digit_press_seq(:A, 4), do: [:^, :^, :<, :<, :A]
  defp digit_press_seq(:A, 5), do: [:^, :^, :<, :A]
  defp digit_press_seq(:A, 6), do: [:^, :^, :A]
  defp digit_press_seq(:A, 7), do: [:^, :^, :^, :<, :<, :A]
  defp digit_press_seq(:A, 8), do: [:^, :^, :^, :<, :A]
  defp digit_press_seq(:A, 9), do: [:^, :^, :^, :A]
  defp directional_press_seq(:>, :^), do: [:<, :^, :A]
  defp directional_press_seq(:>, :<), do: [:<, :<, :A]
  defp directional_press_seq(:>, :v), do: [:<, :A]
  defp directional_press_seq(:>, :A), do: [:^, :A]
  defp directional_press_seq(:^, :>), do: [:>, :v, :A]
  defp directional_press_seq(:^, :<), do: [:v, :<, :A]
  defp directional_press_seq(:^, :v), do: [:v, :A]
  defp directional_press_seq(:^, :A), do: [:>, :A]
  defp directional_press_seq(:<, :>), do: [:>, :>, :A]
  defp directional_press_seq(:<, :^), do: [:>, :^, :A]
  defp directional_press_seq(:<, :v), do: [:>, :A]
  defp directional_press_seq(:<, :A), do: [:>, :>, :^, :A]
  defp directional_press_seq(:v, :>), do: [:>, :A]
  defp directional_press_seq(:v, :^), do: [:^, :A]
  defp directional_press_seq(:v, :<), do: [:<, :A]
  defp directional_press_seq(:v, :A), do: [:>, :^, :A]
  defp directional_press_seq(:A, :>), do: [:v, :A]
  defp directional_press_seq(:A, :^), do: [:<, :A]
  defp directional_press_seq(:A, :<), do: [:v, :<, :<, :A]
  defp directional_press_seq(:A, :v), do: [:v, :<, :A]

  defp directional_press_seq(same, same), do: [:A]

  # def part_two(problem) do
  #   problem
  # end
end
