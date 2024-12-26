defmodule AdventOfCode.Solutions.Y23.Day09Test do
  alias AdventOfCode.Solutions.Y23.Day09, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 9
  #
  #     mix test test/2023/day9_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 9 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-9-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 9, "sample")
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
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    assert 114 == solve(input, :part_one)
  end

  test "can find next number" do
    assert 18 == Solution.next_num([0, 3, 6, 9, 12, 15])
  end

  @part_one_solution 1_731_106_378

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 9, :part_one)
  end

  test "can find prev number" do
    assert 5 == Solution.prev_num([10, 13, 16, 21, 30, 45])
  end

  @part_two_solution 1087

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 9, :part_two)
  end
end
