defmodule AdventOfCode.Solutions.Y24.Day19Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day19, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one single" do
    input = ~S"""
    r, wr, b, g, bwu, rb, gb, br

    bwurrg
    """

    assert 1 == solve(input, :part_one)
  end

  test "part one example" do
    input = ~S"""
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
    """

    assert 6 == solve(input, :part_one)
  end

  @part_one_solution 283

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 19, :part_one)
  end

  test "part two single brwrr" do
    input = ~S"""
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    """

    assert 2 == solve(input, :part_two)
  end

  test "part two single bggr" do
    input = ~S"""
    r, wr, b, g, bwu, rb, gb, br

    bggr
    """

    assert 1 == solve(input, :part_two)
  end

  test "part two single gbbr" do
    input = ~S"""
    r, wr, b, g, bwu, rb, gb, br

    gbbr
    """

    assert 4 == solve(input, :part_two)
  end

  test "part two single rrbgbr" do
    input = ~S"""
    r, wr, b, g, bwu, rb, gb, br

    rrbgbr
    """

    assert 6 == solve(input, :part_two)
  end

  test "part two elixirforum" do
    input = ~S"""
    b, r, br, w, u, wu

    brwu
    """

    # possible splits

    # b  | r | w | u
    # b  | r | wu
    # br | w | u
    # br | wu

    assert 4 == solve(input, :part_two)
  end

  test "part two example" do
    input = ~S"""
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
    """

    assert 16 == solve(input, :part_two)
  end

  @part_two_solution 615_388_132_411_142

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 19, :part_two)
  end
end
