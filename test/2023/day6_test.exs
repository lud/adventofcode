defmodule AdventOfCode.Y23.Day6Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day6, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 6
  #
  #     mix test test/2023/day6_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 6 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-6-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 6, "sample")
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
    Time:      7  15   30
    Distance:  9  40  200
    """

    assert 288 == solve(input, :part_one)
  end

  @part_one_solution 4_403_592

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 6, :part_one)
  end

  test "part two example" do
    input = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    assert 71503 == solve(input, :part_two)
  end

  @part_two_solution 38_017_587

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 6, :part_two)
  end
end
