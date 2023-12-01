defmodule Aoe.Y20.Day2Test do
  use ExUnit.Case, async: true

  alias Aoe.Y20.Day2, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_2_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 2 --part 1
  #
  # Use sample input: 
  #
  #     {:ok, path} = Input.resolve(2020, 2, "sample-1")
  #

  test "verify 2020/2 part_one - samples" do
    problem =
      """
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """
      |> Input.as_file()
      |> Solution.read_file!(:part_one)
      |> Solution.parse_input!(:part_one)

    expected = 2
    assert expected == Solution.part_one(problem)

    # expected = CHANGE_ME
    # assert expected == Solution.part_two(problem)
  end

  test "verify 2020/2 part_two - samples" do
    problem =
      """
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
      """
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 1
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 519

  test "verify 2020/2 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2020, 2, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 708

  test "verify 2020/2 part two" do
    assert {:ok, @part_two_solution} == Aoe.run(2020, 2, :part_two)
  end
end
