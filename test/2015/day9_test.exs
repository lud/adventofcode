defmodule AdventOfCode.Y15.Day9Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day9, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 9
  #
  #     mix test test/2015/day9_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 9 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-9-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 9, "sample")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    This is an
    example input.
    replace with
    an example from
    the AoC website.
    """

    assert CHANGE_ME == solve(input, :part_one)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "part one solution" do
  #   assert {:ok, @part_one_solution} == AoC.run(2015, 9, :part_one)
  # end

  # test "part two example" do
  #   input = ~S"""
  #   This is an
  #   example input.
  #   replace with
  #   an example from
  #   the AoC website.
  #   """
  #
  #   assert CHANGE_ME == solve(input, :part_two)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2015, 9, :part_two)
  # end
end