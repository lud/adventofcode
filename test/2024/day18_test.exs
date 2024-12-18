defmodule AdventOfCode.Solutions.Y24.Day18Test do
  alias AdventOfCode.BinarySearch
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day18, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem, 0..6, 12])
  end

  test "part one example" do
    input = ~S"""
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """

    assert 22 == solve(input, :part_one)
  end

  @part_one_solution 262

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 18, :part_one)
  end

  test "part two example" do
    input = ~S"""
     5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """

    assert "6,1" == solve(input, :part_two)
  end

  @part_two_solution "22,20"

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 18, :part_two)
  end
end
