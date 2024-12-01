defmodule AdventOfCode.Solutions.Y24.Day01Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day01, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert 11 == solve(input, :part_one)
  end

  @part_one_solution 1_258_579

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 1, :part_one)
  end

  test "part two example" do
    input = ~S"""
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert 31 == solve(input, :part_two)
  end

  @part_two_solution 23_981_443

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 1, :part_two)
  end
end
