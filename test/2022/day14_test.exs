defmodule AdventOfCode.Y22.Day14Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y22.Day14, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_14_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 14 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 14, "sample-1")
  #

  @sample_1 """
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
  """

  test "verify 2022/14 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 24
    assert expected == Solution.part_one(problem)
  end

  test "verify 2022/14 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 93
    assert expected == Solution.part_two(problem)
  end

  test "verify 2022/14 part_two - alternative" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 93
    assert expected == Solution.part_two_alt(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2022/14 part one" do
  #   assert {:ok, @part_one_solution} == AoC.run(2022, 14, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2022/14 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2022, 14, :part_two)
  # end
end
