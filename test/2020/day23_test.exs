defmodule AdventOfCode.Y20.Day23Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y20.Day23, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_23_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 23 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 23, "sample-1")
  #

  @sample_1 """
  389125467
  """

  test "verify 2020/23 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    # problem = [3, 8, 9, 1, 2, 5, 4, 6..7]

    expected = "92658374"
    assert expected == Solution.part_one(problem, 10)
  end

  # test "verify 2020/23 part_one - big sample" do
  #   problem = [3, 8, 9, 1, 2, 5, 4, 6, 7] ++ Enum.to_list(10..20)
  #   Solution.part_one(problem, 100)
  # end

  # test "verify 2020/23 part_one - ordered" do
  #   problem = Enum.to_list(1..9)
  #   Solution.part_one(problem, 100)
  # end

  # test "verify 2020/23 part_two - samples" do
  #   problem =
  #     @sample_1
  #     |> Input.as_file()
  #     |> Solution.read_file(:part_two)
  #     |> Solution.parse_input(:part_two)

  #   expected = 149_245_887_792
  #   assert expected == Solution.part_two(problem)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution "98645732"

  test "verify 2020/23 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 23, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution 689_500_518_476

  # test "verify 2020/23 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2020, 23, :part_two)
  # end
end
