defmodule AdventOfCode.Y23.Day8Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day8, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 8
  #
  #     mix test test/2023/day8_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 8 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-8-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 8, "sample")
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
    input = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

    assert 6 == solve(input, :part_one)
  end

  @part_one_solution 15871

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 8, :part_one)
  end

  test "part two example" do
    input = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

    assert 6 == solve(input, :part_two)
  end

  @part_two_solution 11_283_670_395_017

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 8, :part_two)
  end
end
