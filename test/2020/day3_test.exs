defmodule AdventOfCode.Solutions.Y20.Day3Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Solutions.Y20.Day3, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_3_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 3 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 3, "sample-1")
  #

  test "verify 2020/3 part_one - samples" do
    problem =
      """
      ..##.......
      #...#...#..
      .#....#..#.
      ..#.#...#.#
      .#...##..#.
      ..#.##.....
      .#.#.#....#
      .#........#
      #.##...#...
      #...##....#
      .#..#...#.#
      """
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 7
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/3 part_two - samples" do
    problem =
      """
      ..##.......
      #...#...#..
      .#....#..#.
      ..#.#...#.#
      .#...##..#.
      ..#.##.....
      .#.#.#....#
      .#........#
      #.##...#...
      #...##....#
      .#..#...#.#
      """
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 336
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 205

  test "verify 2020/3 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 3, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 3_952_146_825

  test "verify 2020/3 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 3, :part_two)
  end
end
