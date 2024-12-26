defmodule AdventOfCode.Solutions.Y23.Day21Test do
  alias AdventOfCode.Solutions.Y23.Day21, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 21
  #
  #     mix test test/2023/day21_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 21 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-21-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 21, "sample")
  #
  # Good luck!

  defp solve(input, part, steps) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [{problem, steps}])
  end

  test "part one example" do
    input = ~S"""
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
    """

    assert 2 == solve(input, :part_one, 1)
    assert 16 == solve(input, :part_one, 6)
  end

  @part_one_solution 3594

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 21, :part_one)
  end

  # There is no test for p2, the input is tailored but the sample input is not.

  @part_two_solution 605_247_138_198_755

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 21, :part_two)
  end
end
