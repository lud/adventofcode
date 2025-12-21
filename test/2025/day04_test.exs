defmodule AdventOfCode.Solutions.Y25.Day04Test do
  alias AdventOfCode.Solutions.Y25.Day04, as: Solution, warn: false
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
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    assert 13 == solve(input, :part_one)
  end

  @part_one_solution 1560

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 4, :part_one)
  end

  test "part two example" do
    input = ~S"""
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    assert 43 == solve(input, :part_two)
  end

  @part_two_solution 9609

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2025, 4, :part_two)
  end
end
