defmodule AdventOfCode.Solutions.Y15.Day11Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y15.Day11, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 11
  #
  #     mix test test/2015/day11_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 11 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-11-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 11, "sample")
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
    abcdefgh
    """

    assert "abcdffaa" == solve(input, :part_one)
  end

  @part_one_solution "hxbxxyzz"

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 11, :part_one)
  end

  @part_two_solution "hxcaabcc"

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 11, :part_two)
  end
end
