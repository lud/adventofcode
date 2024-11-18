defmodule AdventOfCode.Solutions.Y22.Day13Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Solutions.Y22.Day13, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_13_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 13 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 13, "sample-1")
  #

  @sample_1 """
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
  """

  test "verify 2022/13 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 13
    assert expected == Solution.part_one(problem)
  end

  test "ordering" do
    assert :lt == Solution.compare([1, 1, 3, 1, 1], [1, 1, 5, 1, 1])
    assert :lt == Solution.compare([[1], [2, 3, 4]], [[1], 4])
    assert :gt == Solution.compare([9], [[8, 7, 6]])
    assert :lt == Solution.compare([[4, 4], 4, 4], [[4, 4], 4, 4, 4])
    assert :gt == Solution.compare([7, 7, 7, 7], [7, 7, 7])
    assert :lt == Solution.compare([], [3])
    assert :gt == Solution.compare([[[]]], [[]])

    assert :gt ==
             Solution.compare([1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [
               1,
               [2, [3, [4, [5, 6, 0]]]],
               8,
               9
             ])
  end

  test "verify 2022/13 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 140
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 5013

  test "verify 2022/13 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2022, 13, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 25038

  test "verify 2022/13 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2022, 13, :part_two)
  end
end
