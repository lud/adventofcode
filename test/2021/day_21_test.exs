defmodule Aoe.Y21.Day21Test do
  use ExUnit.Case, async: true

  alias Aoe.Y21.Day21, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2021/day_21_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2021 --day 21 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2021, 21, "sample-1")
  #

  @sample_1 """
  Player 1 starting position: 4
  Player 2 starting position: 8
  """

  # test "verify 2021/21 part_one - samples" do
  #   problem =
  #     @sample_1
  #     |> Input.as_file()
  #     |> Solution.read_file!(:part_one)
  #     |> Solution.parse_input!(:part_one)

  #   expected = CHANGE_ME
  #   assert expected == Solution.part_one(problem)
  # end

  test "verify 2021/21 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 444_356_092_776_315
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  # @part_one_solution CHANGE_ME
  #
  # test "verify 2021/21 part one" do
  #   assert {:ok, @part_one_solution} == Aoe.run(2021, 21, :part_one)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2021/21 part two" do
  #   assert {:ok, @part_two_solution} == Aoe.run(2021, 21, :part_two)
  # end
end
