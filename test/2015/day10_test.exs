defmodule AdventOfCode.Solutions.Y15.Day10Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y15.Day10, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 10
  #
  #     mix test test/2015/day10_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 10 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-10-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 10, "sample")
  #
  # Good luck!

  defp solve(input, part, times) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [{problem, times}])
  end

  test "part one example" do
    input = ~S"""
    1
    """

    # result is "312211" so length is 6
    assert 6 == solve(input, :part_one, 5)
  end

  @part_one_solution 492_982

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 10, :part_one)
  end

  @part_two_solution 6_989_950

  @tag :slow
  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 10, :part_two)
  end
end
