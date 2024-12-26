defmodule AdventOfCode.Solutions.Y15.Day03Test do
  alias AdventOfCode.Solutions.Y15.Day03, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 3
  #
  #     mix test test/2015/day3_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 3 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-3-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 3, "sample")
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
    ^>v<
    """

    assert 4 == solve(input, :part_one)
  end

  @part_one_solution 2572

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 3, :part_one)
  end

  test "part two example" do
    input = ~S"""
    ^v^v^v^v^v
    """

    assert 11 == solve(input, :part_two)
  end

  @part_two_solution 2631

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 3, :part_two)
  end
end
