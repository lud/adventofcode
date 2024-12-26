defmodule AdventOfCode.Solutions.Y23.Day23Test do
  alias AdventOfCode.Solutions.Y23.Day23, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 23
  #
  #     mix test test/2023/day23_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 23 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-23-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 23, "sample")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    #.#####################
    #.......#########...###
    #######.#########.#.###
    ###.....#.>.>.###.#.###
    ###v#####.#v#.###.#.###
    ###.>...#.#.#.....#...#
    ###v###.#.#.#########.#
    ###...#.#.#.......#...#
    #####.#.#.#######.#.###
    #.....#.#.#.......#...#
    #.#####.#.#.#########v#
    #.#...#...#...###...>.#
    #.#.#v#######v###.###v#
    #...#.>.#...>.>.#.###.#
    #####v#.#.###v#.#.###.#
    #.....#...#...#.#.#...#
    #.#########.###.#.#.###
    #...###...#...#...#.###
    ###.###.#.###v#####v###
    #...#...#.#.>.>.#.>.###
    #.###.###.#.###.#.#v###
    #.....###...###...#...#
    #####################.#
    """

    assert 94 == solve(input, :part_one)
  end

  @part_one_solution 2250

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 23, :part_one)
  end

  test "part two example" do
    input = ~S"""
    #.#####################
    #.......#########...###
    #######.#########.#.###
    ###.....#.>.>.###.#.###
    ###v#####.#v#.###.#.###
    ###.>...#.#.#.....#...#
    ###v###.#.#.#########.#
    ###...#.#.#.......#...#
    #####.#.#.#######.#.###
    #.....#.#.#.......#...#
    #.#####.#.#.#########v#
    #.#...#...#...###...>.#
    #.#.#v#######v###.###v#
    #...#.>.#...>.>.#.###.#
    #####v#.#.###v#.#.###.#
    #.....#...#...#.#.#...#
    #.#########.###.#.#.###
    #...###...#...#...#.###
    ###.###.#.###v#####v###
    #...#...#.#.>.>.#.>.###
    #.###.###.#.###.#.#v###
    #.....###...###...#...#
    #####################.#
    """

    assert 154 == solve(input, :part_two)
  end

  @part_two_solution 6470

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 23, :part_two)
  end
end
