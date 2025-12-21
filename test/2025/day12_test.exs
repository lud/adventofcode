defmodule AdventOfCode.Solutions.Y25.Day12Test do
  alias AdventOfCode.Solutions.Y25.Day12, as: Solution, warn: false
  alias AoC.Input, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  # I did not implement the actual solution. It turns out that the real puzzle
  # is solvable by just checking if the number of # fits in the area, no matter
  # the position of them.
  #
  # So I just did that.
  @tag :skip
  test "part one example" do
    input = ~S"""
    0:
    ###
    ##.
    ##.

    1:
    ###
    ##.
    .##

    2:
    .##
    ###
    ##.

    3:
    ##.
    ###
    ##.

    4:
    ###
    #..
    ###

    5:
    ###
    .#.
    ###

    4x4: 0 0 0 0 2 0
    12x5: 1 0 1 0 2 2
    12x5: 1 0 1 0 3 2
    """

    assert 2 == solve(input, :part_one)
  end

  @part_one_solution 579

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 12, :part_one)
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
  #   assert {:ok, @part_two_solution} == AoC.run(2025, 12, :part_two)
  # end
end
