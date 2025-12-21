defmodule AdventOfCode.Solutions.Y25.Day01Test do
  alias AdventOfCode.Solutions.Y25.Day01, as: Solution, warn: false
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
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

    assert 3 == solve(input, :part_one)
  end

  @part_one_solution 1040

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 1, :part_one)
  end

  test "part two special" do
    input = ~S"""
    R1000
    """

    assert 10 == solve(input, :part_two)
  end

  test "part two example" do
    input = ~S"""
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

    assert 6 == solve(input, :part_two)
  end

  @part_two_solution 6027

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2025, 1, :part_two)
  end
end
