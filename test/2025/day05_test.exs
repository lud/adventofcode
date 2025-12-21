defmodule AdventOfCode.Solutions.Y25.Day05Test do
  alias AdventOfCode.Solutions.Y25.Day05, as: Solution, warn: false
  alias AoC.Input, warn: false
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
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

    assert 3 == solve(input, :part_one)
  end

  @part_one_solution 525

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 5, :part_one)
  end

  test "part two example" do
    input = ~S"""
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

    assert 14 == solve(input, :part_two)
  end

  @part_two_solution 333_892_124_923_577

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2025, 5, :part_two)
  end
end
