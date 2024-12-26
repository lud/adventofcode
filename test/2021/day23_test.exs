defmodule AdventOfCode.Solutions.Y21.Day23Test do
  alias AdventOfCode.Solutions.Y21.Day23, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2021/day_23_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2021 --day 23 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2021, 23, "sample-1")
  #

  @sample_1 """
  #############
  #...........#
  ###B#A#C#D###
    #A#B#C#D#
    #########
  """

  test "verify 2021/23 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 46
    assert expected == Solution.part_one(problem)
  end

  # test "check moves" do
  #   world =
  #     @sample_1
  #     |> Input.as_file()
  #     |> Solution.read_file(:part_one)
  #     |> Solution.parse_input(:part_one)

  #   world = move(world, {4, 1}, {5, 0})
  #   assert world.nrj == 2
  #   Solution.print_world(world)

  #   IO.puts("POSSIBLE:")
  #   nexts = Solution.possible_nexts(world)

  #   Enum.map(nexts, fn w ->
  #     Solution.print_world(w)
  #   end)

  #   # world = move(world, {2, 1}, {4, 1})
  #   # assert world.nrj == 42
  #   # Solution.print_world(world)

  #   Solution.part_one(world)
  # end

  # defp move(world, from, to) do
  #   steps = Solution.calc_steps(from, to)
  #   Solution.move(world, from, to, steps)
  # end

  # test "verify 2021/23 part_two - samples" do
  #   problem =
  #     @sample_1
  #     |> Input.as_file()
  #     |> Solution.read_file(:part_two)
  #     |> Solution.parse_input(:part_two)
  #
  #   expected = CHANGE_ME
  #   assert expected == Solution.part_two(problem)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2021/23 part one" do
  #   assert {:ok, @part_one_solution} == AoC.run(2021, 23, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2021/23 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2021, 23, :part_two)
  # end
end
