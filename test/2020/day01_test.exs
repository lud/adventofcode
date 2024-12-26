defmodule AdventOfCode.Solutions.Y20.Day01Test do
  alias AdventOfCode.Solutions.Y20.Day01, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  test "verify 2020/1 - sample 1" do
    problem =
      """
      1721
      979
      366
      299
      675
      1456
      """
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected_one = 514_579
    assert expected_one == Solution.part_one(problem)

    expected_two = 241_861_950
    assert expected_two == Solution.part_two(problem)
  end

  @part_one_solution 1_014_171

  test "verify 2020/1 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 1, :part_one)
  end

  @part_two_solution 46_584_630

  test "verify 2020/1 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 1, :part_two)
  end
end
