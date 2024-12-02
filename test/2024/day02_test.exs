defmodule AdventOfCode.Solutions.Y24.Day02Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day02, as: Solution, warn: false
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
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    assert 2 == solve(input, :part_one)
  end

  @part_one_solution 287

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 2, :part_one)
  end

  test "part two example" do
    input = ~S"""
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    assert 4 == solve(input, :part_two)
  end

  @part_two_solution 354

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 2, :part_two)
  end
end
