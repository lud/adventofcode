defmodule AdventOfCode.Y15.Day8Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day8, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 8
  #
  #     mix test test/2015/day8_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 8 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-8-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 8, "sample")
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
    ""
    "abc"
    "aaa\"aaa"
    "\x27"
    """

    assert 12 == solve(input, :part_one)
  end

  @part_one_solution 1342

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 8, :part_one)
  end

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
  #   assert {:ok, @part_two_solution} == AoC.run(2015, 8, :part_two)
  # end
end
