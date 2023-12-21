defmodule AdventOfCode.Y23.Day21Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day21, as: Solution, warn: false
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

    assert 16 == solve(input, :part_one, 6)
  end

  @part_one_solution 3594

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 21, :part_one)
  end

  # test "part two example" do
  #   input = ~S"""
  #   This is an
  #   example input.
  #   replace with
  #   an example from
  #   the AoC website.
  #   """
  #
  #   assert CHANGE_ME == solve(input, :part_two)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2023, 21, :part_two)
  # end
end
