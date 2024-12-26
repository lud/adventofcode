defmodule AdventOfCode.Solutions.Y23.Day18Test do
  alias AdventOfCode.Solutions.Y23.Day18, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 18
  #
  #     mix test test/2023/day18_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 18 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-18-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 18, "sample")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    """

    assert 62 == solve(input, :part_one)
  end

  @part_one_solution 68115

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 18, :part_one)
  end

  test "part two example" do
    input = ~S"""
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    """

    assert 952_408_144_115 == solve(input, :part_two)
  end

  @part_two_solution 71_262_565_063_800

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 18, :part_two)
  end
end
