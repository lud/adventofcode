defmodule AdventOfCode.Solutions.Y24.Day16Test do
  alias AdventOfCode.Solutions.Y24.Day16, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """

    assert 7036 == solve(input, :part_one)
  end

  @part_one_solution 107_468

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 16, :part_one)
  end

  test "part two example" do
    input = ~S"""
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """

    assert 45 == solve(input, :part_two)
  end

  @part_two_solution 533

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 16, :part_two)
  end
end
