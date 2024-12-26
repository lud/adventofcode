defmodule AdventOfCode.Solutions.Y20.Day07Test do
  alias AdventOfCode.Solutions.Y20.Day07, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_7_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 7 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 7, "sample-1")
  #

  test "verify 2020/7 part_one - samples" do
    problem =
      """
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
      """
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 4
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/7 part_two - samples" do
    problem =
      """
      shiny gold bags contain 2 dark red bags.
      dark red bags contain 2 dark orange bags.
      dark orange bags contain 2 dark yellow bags.
      dark yellow bags contain 2 dark green bags.
      dark green bags contain 2 dark blue bags.
      dark blue bags contain 2 dark violet bags.
      dark violet bags contain no other bags.
      """
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 126
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 139

  test "verify 2020/7 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 7, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 58175

  test "verify 2020/7 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2020, 7, :part_two)
  end
end
