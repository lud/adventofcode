defmodule AdventOfCode.Y23.Day11Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day11, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 11
  #
  #     mix test test/2023/day11_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 11 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-11-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 11, "sample")
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
    input = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

    assert 374 == solve(input, :part_one)
  end

  @part_one_solution 9_521_776

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 11, :part_one)
  end

  test "part two example" do
    input = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(:no_part)
      |> Solution.parse_input(:no_part)

    assert 1030 = Solution.solve(problem, 10)
    assert 8410 = Solution.solve(problem, 100)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2023, 11, :part_two)
  # end
end
