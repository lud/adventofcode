defmodule AdventOfCode.Solutions.Y20.Day12Test do
  alias AdventOfCode.Solutions.Y20.Day12, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_12_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 12 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 12, "sample-1")
  #

  @sample_1 """
  F10
  N3
  F7
  R90
  F11
  """

  test "verify 2020/12 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 25
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/12 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 286
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 757

  test "verify 2020/12 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 12, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 51249

  test "verify 2020/12 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 12, :part_two)
  end
end
