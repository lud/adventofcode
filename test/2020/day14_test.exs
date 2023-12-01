defmodule Aoe.Y20.Day14Test do
  use ExUnit.Case, async: true

  alias Aoe.Y20.Day14, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_14_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 14 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 14, "sample-1")
  #

  @sample_1 """
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """

  test "verify 2020/14 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 165
    assert expected == Solution.part_one(problem)
  end

  @sample_2 """
  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
  """

  test "verify 2020/14 part_two - samples" do
    problem =
      @sample_2
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 208
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 12_408_060_320_841

  test "verify 2020/14 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2020, 14, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 4_466_434_626_828

  test "verify 2020/14 part two" do
    assert {:ok, @part_two_solution} == Aoe.run(2020, 14, :part_two)
  end
end
