defmodule AdventOfCode.Solutions.Y20.Day08Test do
  alias AdventOfCode.Solutions.Y20.Day08, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_8_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 8 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 8, "sample-1")
  #

  test "verify 2020/8 part_one - samples" do
    problem =
      """
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
      """
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 5
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/8 part_two - samples" do
    problem =
      """
      nop +0
      acc +1
      jmp +4
      acc +3
      jmp -3
      acc -99
      acc +1
      jmp -4
      acc +6
      """
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 8
    assert expected == Solution.part_two(problem)

    # expected = CHANGE_ME
    # assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 1548

  test "verify 2020/8 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 8, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 1375

  test "verify 2020/8 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 8, :part_two)
  end
end
