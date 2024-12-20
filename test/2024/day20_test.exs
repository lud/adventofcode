defmodule AdventOfCode.Solutions.Y24.Day20Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day20, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part, args \\ []) do
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

    assert 2 == solve(input, :part_one, [_save_at_least = 40])
  end

  @part_one_solution 1459

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 20, :part_one)
  end

  # test "part two example" do
  #   input = ~S"""
  #   This is an
  #   example input.
  #   replace with
  #   an example from
  #   the AoC website.
  #   """
  #
  #   assert CHANGE_ME == solve(input, :part_two)
  # end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2024, 20, :part_two)
  # end
end
