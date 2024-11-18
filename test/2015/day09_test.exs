defmodule AdventOfCode.Solutions.Y15.Day09Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y15.Day09, as: Solution, warn: false
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
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
    """

    assert 605 == solve(input, :part_one)
  end

  @part_one_solution 141

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 9, :part_one)
  end

  test "part two example" do
    input = ~S"""
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
    """

    assert 982 == solve(input, :part_two)
  end

  @part_two_solution 736

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 9, :part_two)
  end
end
