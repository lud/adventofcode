defmodule AdventOfCode.Solutions.Y23.Day14Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y23.Day14, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 14
  #
  #     mix test test/2023/day14_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 14 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-14-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 14, "sample")
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
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

    assert 136 == solve(input, :part_one)
  end

  @part_one_solution 108_889

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 14, :part_one)
  end

  test "part two example" do
    input = """
    O....#....
    O.OO#....#
    .....##...
    OO.#O....O
    .O.....O#.
    O.#..O.#.#
    ..O..#O..O
    .......O..
    #....###..
    #OO..#....
    """

    assert 64 == solve(input, :part_two)
  end

  @part_two_solution 104_671

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 14, :part_two)
  end
end
