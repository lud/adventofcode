defmodule AdventOfCode.Solutions.Y24.Day14Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day14, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part, room_dimensions) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem, room_dimensions])
  end

  test "part one example" do
    input = ~S"""
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3
    """

    assert 12 == solve(input, :part_one, {11, 7})
  end

  @part_one_solution 231_221_760

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 14, :part_one)
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
  #   assert {:ok, @part_two_solution} == AoC.run(2024, 14, :part_two)
  # end
end
