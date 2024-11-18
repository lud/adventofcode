defmodule AdventOfCode.Solutions.Y21.Day18Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Solutions.Y21.Day18, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2021/day_18_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2021 --day 18 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2021, 18, "sample-1")
  #

  @sample_1 """
  [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
  [[[5,[2,8]],4],[5,[[9,9],0]]]
  [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
  [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
  [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
  [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
  [[[[5,4],[7,7]],8],[[8,3],8]]
  [[9,3],[[9,9],[6,[4,9]]]]
  [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
  [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
  """

  test "verify 2021/18 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = 4140
    assert expected == Solution.part_one(problem)
  end

  defp to_problem(raw_input, part \\ :part_one) do
    raw_input
    |> Input.as_file()
    |> Solution.read_file(part)
    |> Solution.parse_input(part)
  end

  test "sample list 1" do
    input =
      """
      [1,1]
      [2,2]
      [3,3]
      [4,4]
      """
      |> to_problem()

    assert [[[[1, 1], [2, 2]], [3, 3]], [4, 4]] == Solution.add_all(input) |> Solution.to_list()
  end

  test "sample list 2" do
    input =
      """
      [1,1]
      [2,2]
      [3,3]
      [4,4]
      [5,5]
      """
      |> to_problem()

    assert [[[[3, 0], [5, 3]], [4, 4]], [5, 5]] == Solution.add_all(input) |> Solution.to_list()
  end

  test "magnitude" do
    assert 143 == "[[1,2],[[3,4],5]]" |> to_problem() |> hd |> Solution.magnitude()

    assert 1384 ==
             "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]" |> to_problem() |> hd |> Solution.magnitude()

    assert 3488 ==
             "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] "
             |> to_problem()
             |> hd
             |> Solution.magnitude()
  end

  test "verify 2021/18 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_two)
      |> Solution.parse_input(:part_two)

    expected = 3993
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 3665

  test "verify 2021/18 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2021, 18, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2021/18 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2021, 18, :part_two)
  # end
end
