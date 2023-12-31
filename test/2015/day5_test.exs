defmodule AdventOfCode.Y15.Day5Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day5, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 5
  #
  #     mix test test/2015/day5_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 5 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-5-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 5, "sample")
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
    assert Solution.nice?("ugknbfddgicrmopn")
    assert Solution.nice?("aaa")
    refute Solution.nice?("jchzalrnumimnmhp")
    refute Solution.nice?("haegwjzuvuyypxyu")
    refute Solution.nice?("dvszwmarrgswjxmb")
  end

  @part_one_solution 258

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 5, :part_one)
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
  #   assert {:ok, @part_two_solution} == AoC.run(2015, 5, :part_two)
  # end
end
