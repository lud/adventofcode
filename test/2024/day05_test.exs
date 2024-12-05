defmodule AdventOfCode.Solutions.Y24.Day05Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day05, as: Solution, warn: false
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
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

    assert 143 == solve(input, :part_one)
  end

  @part_one_solution 5208

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 5, :part_one)
  end

  test "part two example" do
    input = ~S"""
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

    assert 123 == solve(input, :part_two)
  end

  @part_two_solution 6732

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 5, :part_two)
  end
end
