defmodule AdventOfCode.Solutions.Y22.Day21Test do
  alias AdventOfCode.Solutions.Y22.Day21, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_21_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 21 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 21, "sample-1")
  #

  @sample_1 """
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
  """

  test "verify 2022/21 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 152
    assert expected == Solution.part_one(problem)
  end

  test "verify 2022/21 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 301
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2022/21 part one" do
  #   assert {:ok, @part_one_solution} == AoC.run(2022, 21, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2022/21 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2022, 21, :part_two)
  # end
end
