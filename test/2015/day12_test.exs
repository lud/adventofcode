defmodule AdventOfCode.Y15.Day12Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day12, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 12
  #
  #     mix test test/2015/day12_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 12 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-12-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 12, "sample")
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
    {"x": [1,2,3], "map": {"a":2,"b":4}}
    """

    assert 12 == solve(input, :part_one)
  end

  test "part one example 2" do
    input = ~S"""
    {"a":[-1,1]}
    """

    assert 0 == solve(input, :part_one)
  end

  test "part one example empty" do
    input = ~S"""
    []
    """

    assert 0 == solve(input, :part_one)
  end

  @part_one_solution 191_164

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 12, :part_one)
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
  #   assert {:ok, @part_two_solution} == AoC.run(2015, 12, :part_two)
  # end
end
