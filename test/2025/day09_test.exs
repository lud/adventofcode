defmodule AdventOfCode.Solutions.Y25.Day09Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y25.Day09, as: Solution, warn: false
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
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

    assert 50 == solve(input, :part_one)
  end

  @part_one_solution 4_772_103_936

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 9, :part_one)
  end

  test "part two example" do
    input = ~S"""
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

    assert 24 == solve(input, :part_two)
  end

  @part_two_solution 1_529_675_217

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2025, 9, :part_two)
  end
end
