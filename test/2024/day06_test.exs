defmodule AdventOfCode.Solutions.Y24.Day06Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day06, as: Solution, warn: false
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
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    assert 41 == solve(input, :part_one)
  end

  @part_one_solution 5153

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 6, :part_one)
  end

  test "part two example" do
    input = ~S"""
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    assert 6 == solve(input, :part_two)
  end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2024, 6, :part_two)
  # end
end
