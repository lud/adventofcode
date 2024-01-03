defmodule AdventOfCode.Y15.Day15Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day15, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 15
  #
  #     mix test test/2015/day15_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 15 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-15-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 15, "sample")
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
    Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
    Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
    """

    assert 62_842_880 == solve(input, :part_one)
  end

  @part_one_solution 13_882_464

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 15, :part_one)
  end

  test "part two example" do
    input = ~S"""
    Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
    Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
    """

    assert 57_600_000 == solve(input, :part_two)
  end

  @part_two_solution 11_171_160

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 15, :part_two)
  end
end
