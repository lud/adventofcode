defmodule AdventOfCode.Y20.Day25Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y20.Day25, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_25_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 25 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2020, 25, "sample-1")
  #

  @sample_1 """
  5764801
  17807724
  """

  test "verify 2020/25 check public key" do
    assert 5_764_801 == Solution.create_pubkey(8)
    assert 8 == Solution.guess_loopsize(5_764_801)
    assert 17_807_724 == Solution.create_pubkey(11)
    assert 14_897_079 == Solution.create_key(17_807_724, 8)
  end

  test "verify 2020/25 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 14_897_079
    assert expected == Solution.part_one(problem)
  end

  # test "verify 2020/25 part_two - samples" do
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

  @part_one_solution 19_774_660

  test "verify 2020/25 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2020, 25, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2020/25 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2020, 25, :part_two)
  # end
end
