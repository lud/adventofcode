defmodule AdventOfCode.Solutions.Y23.Day04Test do
  alias AdventOfCode.Solutions.Y23.Day04, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 4
  #
  #     mix test test/2023/day4_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 4 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-4-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 4, "sample")
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
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    assert 13 == solve(input, :part_one)
  end

  test "part two example" do
    input = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

    assert 30 == solve(input, :part_two)
  end

  @part_one_solution 19855

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 4, :part_one)
  end

  @part_two_solution 10_378_710

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 4, :part_two)
  end
end
