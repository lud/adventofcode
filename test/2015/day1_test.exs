defmodule AdventOfCode.Y15.Day1Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day1, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 1
  #
  #     mix test test/2015/day1_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 1 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-1-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 1, "sample")
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
    ))(((((
    """

    assert 3 == solve(input, :part_one)
  end

  @part_one_solution 232

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 1, :part_one)
  end

  test "part two example" do
    input = ~S"""
    ()())
    """

    assert 5 == solve(input, :part_two)
  end

  @part_two_solution 1873

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 1, :part_two)
  end
end
