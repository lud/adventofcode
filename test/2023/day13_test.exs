defmodule AdventOfCode.Y23.Day13Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day13, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 13
  #
  #     mix test test/2023/day13_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 13 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-13-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 13, "sample")
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

  test "part one horiz" do
    input = """
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

    assert 400 == solve(input, :part_one)
  end

  test "part one example" do
    input = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.

    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

    assert 405 == solve(input, :part_one)
  end

  test "hard pattern" do
    input = """
    .#..#.#
    #.##..#
    ##.....
    ....##.
    .....#.
    .....#.
    ....##.
    ##.....
    ####..#
    .#..#.#
    ###.##.
    ###.##.
    .#..#.#
    """

    # should not raise
    assert solve(input, :part_one)
  end

  @part_one_solution 34889

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 13, :part_one)
  end

  test "part two example" do
    input = """
    #.##..##.
    ..#.##.#.
    ##......#
    ##......#
    ..#.##.#.
    ..##..##.
    #.#.##.#.
    """

    assert 300 == solve(input, :part_two)
  end

  test "part two example 2" do
    input = """
    #...##..#
    #....#..#
    ..##..###
    #####.##.
    #####.##.
    ..##..###
    #....#..#
    """

    assert 100 == solve(input, :part_two)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2023, 13, :part_two)
  # end
end
