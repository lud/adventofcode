defmodule AdventOfCode.Solutions.Y25.Day03Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y25.Day03, as: Solution, warn: false
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
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

    assert 357 == solve(input, :part_one)
  end

  @part_one_solution 17092

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 3, :part_one)
  end

  # test "part two example" do
  #   input = ~S"""
  #   This is an
  #   example input.
  #   replace with
  #   an example from
  #   the AoC website.
  #   """
  #
  #   assert CHANGE_ME == solve(input, :part_two)
  # end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2025, 3, :part_two)
  # end
end
