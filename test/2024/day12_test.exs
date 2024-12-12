defmodule AdventOfCode.Solutions.Y24.Day12Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day12, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one small" do
    input = ~S"""
    AAAA
    BBCD
    BBCC
    EEEC
    """

    assert 140 == solve(input, :part_one)
  end

  test "part one donut" do
    input = ~S"""
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

    assert 772 == solve(input, :part_one)
  end

  test "part one medium" do
    input = ~S"""
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    assert 1930 == solve(input, :part_one)
  end

  @part_one_solution 1_363_682

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 12, :part_one)
  end

  test "part two small" do
    input = ~S"""
    AAAA
    BBCD
    BBCC
    EEEC
    """

    assert 80 == solve(input, :part_two)
  end

  test "part two donut" do
    input = ~S"""
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

    assert 436 == solve(input, :part_two)
  end

  test "part two big E" do
    input = ~S"""
    EEEEE
    EXXXX
    EEEEE
    EXXXX
    EEEEE
    """

    assert 236 == solve(input, :part_two)
  end

  test "part two damier" do
    input = ~S"""
    AAAAAA
    AAABBA
    AAABBA
    ABBAAA
    ABBAAA
    AAAAAA
    """

    assert 368 == solve(input, :part_two)
  end

  test "part two medium" do
    input = ~S"""
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    assert 1206 == solve(input, :part_two)
  end

  @part_two_solution 787_680

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 12, :part_two)
  end
end
