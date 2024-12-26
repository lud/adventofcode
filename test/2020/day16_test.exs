defmodule AdventOfCode.Solutions.Y20.Day16Test do
  alias AdventOfCode.Solutions.Y20.Day16, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_16_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 16 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 16, "sample-1")
  #

  @sample_1 """
  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12
  """

  test "verify 2020/16 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 71
    assert expected == Solution.part_one(problem)
  end

  # @sample_2 """
  # class: 0-1 or 4-19
  # row: 0-5 or 8-19
  # seat: 0-13 or 16-19

  # your ticket:
  # 11,12,13

  # nearby tickets:
  # 3,9,18
  # 15,1,5
  # 5,14,9
  # """

  # test "verify 2020/16 part_two - samples" do
  #   problem =
  #     @sample_2
  #     |> Input.as_file()
  #     |> Solution.read_file(:part_two)
  #     |> Solution.parse_input(:part_two)

  #   expected = CHANGE_ME
  #   assert expected == Solution.part_two(problem)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 20231

  test "verify 2020/16 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 16, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 1_940_065_747_861

  test "verify 2020/16 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 16, :part_two)
  end
end
