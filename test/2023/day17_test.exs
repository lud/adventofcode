defmodule AdventOfCode.Solutions.Y23.Day17Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y23.Day17, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 17
  #
  #     mix test test/2023/day17_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 17 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-17-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 17, "sample")
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
    input = ~S"""
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
    """

    assert 102 == solve(input, :part_one)
  end

  @part_one_solution 1195

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 17, :part_one)
  end

  test "part two example" do
    input = ~S"""
    2413432311323
    3215453535623
    3255245654254
    3446585845452
    4546657867536
    1438598798454
    4457876987766
    3637877979653
    4654967986887
    4564679986453
    1224686865563
    2546548887735
    4322674655533
    """

    assert 94 == solve(input, :part_two)
  end

  @part_two_solution 1347

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 17, :part_two)
  end
end
