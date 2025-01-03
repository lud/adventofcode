defmodule AdventOfCode.Solutions.Y21.Day25Test do
  alias AdventOfCode.Solutions.Y21.Day25, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2021/day_25_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2021 --day 25 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2021, 25, "sample-1")
  #

  @sample_1 """
  v...>>.vv>
  .vv>>.vv..
  >>.>v>...v
  >>v>>.>.v.
  v>v.vv.v..
  >.>>..v...
  .vv..>.>v.
  v.v..>>v.v
  ....v..v.>
  """

  test "verify 2021/25 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 58
    assert expected == Solution.part_one(problem)
  end

  # test "verify 2021/25 part_two - samples" do
  #   problem =
  #     @sample_1
  #     |> Input.as_file()
  #     |> Solution.read_file(:part_two)
  #     |> Solution.parse_input(:part_two)
  #
  #   expected = CHANGE_ME
  #   assert expected == Solution.part_two(problem)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2021/25 part one" do
  #   assert {:ok, @part_one_solution} == AoC.run(2021, 25, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2021/25 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2021, 25, :part_two)
  # end
end
