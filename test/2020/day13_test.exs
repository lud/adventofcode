defmodule Aoe.Y20.Day13Test do
  use ExUnit.Case, async: true

  alias Aoe.Y20.Day13, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_13_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 13 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 13, "sample-1")
  #

  @sample_1 """
  939
  7,13,x,x,59,x,31,19
  """

  test "verify 2020/13 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 295
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/13 part_two - sample 1" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 1_068_781
    assert expected == Solution.part_two(problem)
  end

  test "verify 2020/13 part_two - tiny sample" do
    problem =
      """
      0
      17,x,13,19
      """
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 3417
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 138

  test "verify 2020/13 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2020, 13, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 226_845_233_210_288

  test "verify 2020/13 part two" do
    assert {:ok, @part_two_solution} == Aoe.run(2020, 13, :part_two)
  end
end
