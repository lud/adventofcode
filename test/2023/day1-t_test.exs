defmodule AdventOfCode.Y23.Day1TTTest do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day1, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2023/day1_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2023 --day 1 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2023, 1, "sample-1")
  #

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    assert 142 == solve(input, :part_one)
  end

  @sample_2 """
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  """

  test "part two example" do
    problem =
      @sample_2
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 281
    assert expected == Solution.part_two(problem)
  end

  @part_one_solution 56042

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 1, :part_one)
  end

  @part_two_solution 55358

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 1, :part_two)
  end
end
