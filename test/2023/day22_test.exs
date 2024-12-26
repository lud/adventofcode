defmodule AdventOfCode.Solutions.Y23.Day22Test do
  alias AdventOfCode.Solutions.Y23.Day22, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 22
  #
  #     mix test test/2023/day22_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 22 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-22-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 22, "sample")
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
    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9
    """

    assert 5 == solve(input, :part_one)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 446
  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 22, :part_one)
  end

  test "part two example" do
    input = ~S"""
    1,0,1~1,2,1
    0,0,2~2,0,2
    0,2,3~2,2,3
    0,0,4~0,2,4
    2,0,5~2,2,5
    0,1,6~2,1,6
    1,1,8~1,1,9
    """

    assert 7 == solve(input, :part_two)
  end

  @part_two_solution 60287

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 22, :part_two)
  end
end
