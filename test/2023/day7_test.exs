defmodule AdventOfCode.Y23.Day7Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day7, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 7
  #
  #     mix test test/2023/day7_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 7 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-7-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 7, "sample")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    assert 6440 == solve(input, :part_one)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 253_603_890

  test "part one solution" do
    assert {:ok, result} = AoC.run(2023, 7, :part_one)

    assert @part_one_solution == result
  end

  test "part two example" do
    input = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    assert 5905 == solve(input, :part_two)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2023, 7, :part_two)
  # end
end
