defmodule AdventOfCode.Solutions.Y24.Day22Test do
  alias AdventOfCode.Solutions.Y24.Day22, as: Solution
  alias AoC.Input
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
    1
    10
    100
    2024
    """

    assert 37_327_623 == solve(input, :part_one)
  end

  @part_one_solution 16_039_090_236

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 22, :part_one)
  end

  test "part two example" do
    input = ~S"""
    1
    2
    3
    2024
    """

    assert 23 == solve(input, :part_two)
  end

  @part_two_solution 1808

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 22, :part_two)
  end
end
