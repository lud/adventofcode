defmodule AdventOfCode.Y23.Day21Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day21, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 21
  #
  #     mix test test/2023/day21_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 21 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-21-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 21, "sample")
  #
  # Good luck!

  defp solve(input, part, steps) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [{problem, steps}])
  end

  test "part one example" do
    input = ~S"""
    ...........
    .....###.#.
    .###.##..#.
    ..#.#...#..
    ....#.#....
    .##..S####.
    .##..#...#.
    .......##..
    .##.#.####.
    .##..##.##.
    ...........
    """

    assert 2 == solve(input, :part_one, 1)
    assert 16 == solve(input, :part_one, 6)
  end

  @part_one_solution 3594

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 21, :part_one)
  end

  # There is no test for p2, the input is tailored but the sample input is not.

  test "pyramid_count" do
    #    1
    #   234
    height_2 = 4

    #     1
    #    234
    #   56789
    height_3 = 9

    #      1
    #     234
    #    56789
    #   0123456
    height_4 = 16

    assert height_2 == Solution.pyramid_count(2)
    assert height_3 == Solution.pyramid_count(3)
    assert height_4 == Solution.pyramid_count(4)
  end

  test "diamond_count" do
    #  1
    # 234
    #  5
    ray_2 = 5

    #   1
    #  234
    # 56789
    #  012
    #   3
    ray_3 = 13

    #    1
    #   234
    #  56789
    # 0123456
    #  78901
    #   234
    #    5
    ray_4 = 25

    assert ray_2 == Solution.diamond_count(2)
    assert ray_3 == Solution.diamond_count(3)
    assert ray_4 == Solution.diamond_count(4)
  end

  @part_two_solution CHANGE_ME

  test "part two solution" do
    bad = 605_206_212_908_755
    {:ok, found} = AoC.run(2023, 21, :part_two)
    bad |> dbg()
    found |> dbg()
    assert bad < found
    # assert {:ok, @part_two_solution} == AoC.run(2023, 21, :part_two)
  end
end
