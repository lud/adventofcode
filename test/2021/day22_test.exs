defmodule AdventOfCode.Y21.Day22Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y21.Day22, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2021/day_22_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2021 --day 22 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2021, 22, "sample-1")
  #

  @sample_1 """
  on x=10..12,y=10..12,z=10..12
  on x=11..13,y=11..13,z=11..13
  off x=9..11,y=9..11,z=9..11
  on x=10..10,y=10..10,z=10..10
  """

  test "verify 2021/22 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 39
    assert expected == Solution.part_one(problem)
  end

  # test "verify 2021/22 part_two - samples" do
  #   problem =
  #     @sample_2
  #     |> Input.as_file()
  #     |> Solution.read_file(:part_two)
  #     |> Solution.parse_input(:part_two)

  #   expected = 2_758_514_936_282_235
  #   assert expected == Solution.part_two(problem)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 580_098

  test "verify 2021/22 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2021, 22, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 1_134_725_012_490_723

  test "verify 2021/22 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2021, 22, :part_two)
  end
end
