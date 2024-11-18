defmodule AdventOfCode.Solutions.Y15.Day04Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y15.Day04, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 4
  #
  #     mix test test/2015/day4_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 4 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-4-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 4, "sample")
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
    abcdef
    """

    assert 609_043 == solve(input, :part_one)
  end

  @part_one_solution 346_386

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 4, :part_one)
  end

  @part_two_solution 9_958_218

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 4, :part_two)
  end
end
