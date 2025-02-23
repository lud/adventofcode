defmodule AdventOfCode.Solutions.Y24.Day20Test do
  alias AdventOfCode.Solutions.Y24.Day20, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  defp solve(input, part, args) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem | args])
  end

  test "part one example" do
    input = ~S"""
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
    """

    # There is one cheat that saves 40 picoseconds.
    # There is one cheat that saves 64 picoseconds.

    assert 2 == solve(input, :part_one, [_save_at_least = 40])
  end

  @part_one_solution 1459

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 20, :part_one)
  end

  test "part two example" do
    input = ~S"""
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
    """

    # There are 12 cheats that save 70 picoseconds.
    # There are 22 cheats that save 72 picoseconds.
    # There are 4 cheats that save 74 picoseconds.
    # There are 3 cheats that save 76 picoseconds.
    41 = 12 + 22 + 4 + 3
    assert 41 == solve(input, :part_two, [_save_at_least = 70])
  end

  @part_two_solution 1_016_066

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 20, :part_two)
  end
end
