defmodule Aoe.Y22.Day16Test do
  use ExUnit.Case, async: true

  alias Aoe.Y22.Day16, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_16_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 16 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 16, "sample-1")
  #

  @sample_1 """
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
  """

  test "verify 2022/16 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file!(:part_one)
      |> Solution.parse_input!(:part_one)

    expected = 1651
    assert expected == Solution.part_one(problem)
  end

  test "verify 2022/16 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 1707
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 1947

  test "verify 2022/16 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2022, 16, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2022/16 part two" do
  #   assert {:ok, @part_two_solution} == Aoe.run(2022, 16, :part_two)
  # end
end
