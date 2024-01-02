defmodule AdventOfCode.Y15.Day13Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y15.Day13, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 13
  #
  #     mix test test/2015/day13_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 13 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-13-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 13, "sample")
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
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
    """

    assert 330 == solve(input, :part_one)
  end

  @part_one_solution 664

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 13, :part_one)
  end

  @part_two_solution 640

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 13, :part_two)
  end
end
