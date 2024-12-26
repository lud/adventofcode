defmodule AdventOfCode.Solutions.Y22.Day19Test do
  alias AdventOfCode.Solutions.Y22.Day19, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_19_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 19 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 19, "sample-1")
  #

  @sample_1 """
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
  """

  test "verify 2022/19 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 33
    assert expected == Solution.part_one(problem)
  end

  @bp_1 "Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian."

  test "parse blueprint" do
    assert {1,
            %{
              rbot: %{ore: 4},
              cbot: %{ore: 2},
              obot: %{ore: 3, clay: 14},
              gbot: %{ore: 2, obsidian: 7}
            }} = Solution.parse_blueprint(@bp_1)
  end

  @bp_2 "Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian."

  test "comp blueprint" do
    {_, bp1} = Solution.parse_blueprint(@bp_1)
    {_, bp2} = Solution.parse_blueprint(@bp_2)
    assert 9 = Solution.best_sim(bp1, 24).geodes
    assert 24 = Solution.best_sim(bp2, 24).geodes * 2
  end

  test "verify 2022/19 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 56 * 62
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2022/19 part one" do
  #   assert {:ok, @part_one_solution} == AoC.run(2022, 19, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2022/19 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2022, 19, :part_two)
  # end
end
