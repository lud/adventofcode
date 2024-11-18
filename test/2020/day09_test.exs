defmodule AdventOfCode.Solutions.Y20.Day09Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Solutions.Y20.Day09, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_9_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 9 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 9, "sample-1")
  #

  test "verify 2020/9 part_one - samples" do
    problem =
      """
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      """
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 127
    assert expected == Solution.part_one(problem, 5)
  end

  test "verify 2020/9 part_two - samples" do
    problem =
      """
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
      """
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 62
    assert expected == Solution.part_two(problem, 5)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 1_212_510_616

  test "verify 2020/9 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 9, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 171_265_123

  test "verify 2020/9 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 9, :part_two)
  end
end
