defmodule AdventOfCode.Y23.Day24Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day24, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 24
  #
  #     mix test test/2023/day24_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 24 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-24-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 24, "sample")
  #
  # Good luck!

  defp solve(input, part, range) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [{problem, range}])
  end

  test "part one example" do
    input = ~S"""
    19, 13, 30 @ -2, 1, -2
    18, 19, 22 @ -1, -1, -2
    20, 25, 34 @ -2, -2, -4
    12, 31, 28 @ -1, -2, -1
    20, 19, 15 @ 1, -5, -3
    """

    assert 2 == solve(input, :part_one, 7..27)
  end

  @part_one_solution 28266

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 24, :part_one)
  end

  @part_two_solution 786_617_045_860_267

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 24, :part_two)
  end
end
