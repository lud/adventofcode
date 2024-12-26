defmodule AdventOfCode.Solutions.Y23.Day01Test do
  alias AdventOfCode.Solutions.Y23.Day01, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 1
  #
  #     mix test test/2023/day1_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 1 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-1-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 1, "sample")
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

  test "part_one example" do
    input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    assert 142 == solve(input, :part_one)
  end

  test "part_two example" do
    input = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

    assert 281 == solve(input, :part_two)
  end

  # Once your part-one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 56042

  test "verify 2023/1 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 1, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 55358

  test "verify 2023/1 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 1, :part_two)
  end
end
