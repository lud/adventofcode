defmodule AdventOfCode.Solutions.Y22.Day22Test do
  alias AdventOfCode.Solutions.Y22.Day22, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_22_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 22 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 22, "sample-1")
  #

  @sample_1 """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """

  test "verify 2022/22 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 6032
    assert expected == Solution.part_one(problem)
  end

  test "verify 2022/22 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 5031
    assert expected == Solution.part_two(problem, 4)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2022/22 part one" do
  #   assert {:ok, @part_one_solution} == AoC.run(2022, 22, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2022/22 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2022, 22, :part_two)
  # end
end
