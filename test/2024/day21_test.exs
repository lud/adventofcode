defmodule AdventOfCode.Solutions.Y24.Day21Test do
  alias AdventOfCode.Solutions.Y24.Day21, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one single" do
    input = ~S"""
    2
    """

    _ = solve(input, :part_one)
  end

  test "part one small" do
    input = ~S"""
    029A
    """

    assert 68 * 29 == solve(input, :part_one)
  end

  test "part one small 2" do
    input = ~S"""
    179A
    """

    assert 68 * 179 == solve(input, :part_one)
  end

  test "part one small 3" do
    input = ~S"""
    379A
    """

    assert 64 * 379 == solve(input, :part_one)
  end

  test "part one example" do
    input = ~S"""
    029A
    980A
    179A
    456A
    379A
    """

    assert 126_384 == solve(input, :part_one)
  end

  @part_one_solution 188_398

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 21, :part_one)
  end

  @part_two_solution 230_049_027_535_970

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 21, :part_two)
  end
end
