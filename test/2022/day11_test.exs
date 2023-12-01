defmodule AdventOfCode.Y22.Day11Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y22.Day11, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_11_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 11 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 11, "sample-1")
  #

  @sample_1 """
    Monkey 0:
    Starting items: 79, 98
    Operation: new = old * 19
    Test: divisible by 23
      If true: throw to monkey 2
      If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
  """

  test "verify 2022/11 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 10605
    assert expected == Solution.part_one(problem)
  end

  test "verify 2022/11 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 2_713_310_158
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 117_624

  test "verify 2022/11 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2022, 11, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 16_792_940_265

  test "verify 2022/11 part two" do
    assert {:ok, @part_two_solution} == AoC.run(2022, 11, :part_two)
  end
end
