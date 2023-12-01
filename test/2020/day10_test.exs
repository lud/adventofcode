defmodule Aoe.Y20.Day10Test do
  use ExUnit.Case, async: true

  alias Aoe.Y20.Day10, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_10_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 10 --part 1
  #
  # Use sample input: 
  #
  #     {:ok, path} = Input.resolve(2020, 10, "sample-1")
  #

  @sample """
  16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4
  """

  test "verify 2020/10 part_one - samples" do
    problem =
      @sample
      |> Input.as_file()
      |> Solution.read_file!(:part_one)
      |> Solution.parse_input!(:part_one)

    expected = 5 * 7
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/10 part_two - samples" do
    problem =
      @sample
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 8
    assert expected == Solution.part_two(problem)
  end

  # test "verify 2020/10 part_two - caveat" do
  #   problem =
  #     "
  #     1
  #     2
  #     3
  #     4
  #     5
  #     6
  #     7
  #     "
  #     |> Input.as_file()
  #     |> Solution.read_file!(:part_two)
  #     |> Solution.parse_input!(:part_two)

  #   expected = 44
  #   assert expected == Solution.part_two(problem)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 2030

  test "verify 2020/10 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2020, 10, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 42_313_823_813_632

  test "verify 2020/10 part two" do
    assert {:ok, @part_two_solution} == Aoe.run(2020, 10, :part_two)
  end
end
