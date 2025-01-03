defmodule AdventOfCode.Solutions.Y15.Day14Test do
  alias AdventOfCode.Solutions.Y15.Day14, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 14
  #
  #     mix test test/2015/day14_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 14 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-14-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 14, "sample")
  #
  # Good luck!

  defp solve(input, part, seconds) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [{problem, seconds}])
  end

  test "part one example" do
    input = ~S"""
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    """

    assert 1120 == solve(input, :part_one, 1000)
  end

  @part_one_solution 2655

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 14, :part_one)
  end

  test "part two example" do
    input = ~S"""
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    """

    assert 689 == solve(input, :part_two, 1000)
  end

  @part_two_solution 1059

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 14, :part_two)
  end
end
