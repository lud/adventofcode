defmodule AdventOfCode.Solutions.Y24.Day10Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day10, as: Solution, warn: false
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
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    assert 36 == solve(input, :part_one)
  end

  @part_one_solution 624

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 10, :part_one)
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
  #   assert {:ok, @part_two_solution} == AoC.run(2024, 10, :part_two)
  # end
end
