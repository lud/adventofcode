defmodule AdventOfCode.Solutions.Y19.Day03Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y19.Day03, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example 1" do
    input = ~S"""
    R8,U5,L5,D3
    U7,R6,D4,L4
    """

    assert 6 == solve(input, :part_one)
  end

  test "part one example 2" do
    input = ~S"""
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    """

    assert 159 == solve(input, :part_one)
  end

  @part_one_solution 1064

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 3, :part_one)
  end

  test "part two example" do
    input = ~S"""
    R8,U5,L5,D3
    U7,R6,D4,L4
    """

    assert 30 == solve(input, :part_two)
  end

  test "part two example 2" do
    input = ~S"""
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    """

    assert 610 == solve(input, :part_two)
  end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2019, 3, :part_two)
  # end
end
