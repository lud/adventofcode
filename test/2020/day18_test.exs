defmodule AdventOfCode.Y20.Day18Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y20.Day18, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_18_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 18 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 18, "sample-1")
  #

  test "verify 2020/18 part_one - samples" do
    tryp1("1 + (2 * 3) + (4 * (5 + 6))", 51)
    tryp1("1 + 2 * 3 + 4 * 5 + 6", 71)
  end

  defp tryp1(line, expected) do
    problem =
      line
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/18 part_two - samples" do
    tryp2("1 + 2 * 3 + 4 * 5 + 6", 231)
    tryp2("1 + (2 * 3) + (4 * (5 + 6))", 51)
  end

  defp tryp2(line, expected) do
    problem =
      line
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 23_507_031_841_020

  test "verify 2020/18 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 18, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 218_621_700_997_826

  test "verify 2020/18 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 18, :part_two)
  end
end
