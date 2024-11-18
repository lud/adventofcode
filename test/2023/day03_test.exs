defmodule AdventOfCode.Solutions.Y23.Day03Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y23.Day03, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 3
  #
  #     mix test test/2023/day3_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 3 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-3-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 3, "sample")
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
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    assert 4361 == solve(input, :part_one)
  end

  @part_one_solution 532_331

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 3, :part_one)
  end

  test "part two example" do
    input = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    assert 467_835 == solve(input, :part_two)
  end

  @part_two_solution 82_301_120

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 3, :part_two)
  end
end
