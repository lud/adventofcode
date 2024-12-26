defmodule AdventOfCode.Solutions.Y15.Day17Test do
  alias AdventOfCode.Solutions.Y15.Day17, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 17
  #
  #     mix test test/2015/day17_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 17 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-17-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 17, "sample")
  #
  # Good luck!

  defp solve(input, part, liters) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [problem, liters])
  end

  test "part one example" do
    input = ~S"""
    20
    15
    10
    5
    5
    """

    assert 4 == solve(input, :part_one, 25)
  end

  @part_one_solution 654

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 17, :part_one)
  end

  test "part two example" do
    input = ~S"""
    20
    15
    10
    5
    5
    """

    assert 3 == solve(input, :part_two, 25)
  end

  @part_two_solution 57

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 17, :part_two)
  end
end
