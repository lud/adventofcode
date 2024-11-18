defmodule AdventOfCode.Solutions.Y15.Day2Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y15.Day2, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 2
  #
  #     mix test test/2015/day2_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 2 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-2-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 2, "sample")
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
    2x3x4
    """

    assert 58 == solve(input, :part_one)
  end

  @part_one_solution 1_588_178

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 2, :part_one)
  end

  test "part two example" do
    input = ~S"""
    2x3x4
    """

    assert 34 == solve(input, :part_two)
  end

  @part_two_solution 3_783_758

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 2, :part_two)
  end
end
