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

  test "part two simple" do
    input = ~S"""
    .....0.
    ..4321.
    ..5..2.
    ..6543.
    ..7..4.
    ..8765.
    ..9....
    """

    assert 3 == solve(input, :part_two)
  end

  test "part two small" do
    input = ~S"""
    012345
    123456
    234567
    345678
    4.6789
    56789.
    """

    assert 227 == solve(input, :part_two)
  end

  test "part two example" do
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

    assert 81 == solve(input, :part_two)
  end

  @part_two_solution 1483

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 10, :part_two)
  end
end
