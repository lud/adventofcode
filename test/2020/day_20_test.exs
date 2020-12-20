defmodule Aoe.Y20.Day20Test do
  use ExUnit.Case, async: true

  alias Aoe.Y20.Day20, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_20_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 20 --part 1
  #
  # Use sample input: 
  #
  #     {:ok, path} = Input.resolve(2020, 20, "sample-1")
  #

  @sample_1 """
  Tile 2311:
  ..##.#..#.
  ##..#.....
  #...##..#.
  ####.#...#
  ##.##.###.
  ##...#.###
  .#.#.#..##
  ..#....#..
  ###...#.#.
  ..###..###

  Tile 1951:
  #.##...##.
  #.####...#
  .....#..##
  #...######
  .##.#....#
  .###.#####
  ###.##.##.
  .###....#.
  ..#.#..#.#
  #...##.#..

  Tile 1171:
  ####...##.
  #..##.#..#
  ##.#..#.#.
  .###.####.
  ..###.####
  .##....##.
  .#...####.
  #.##.####.
  ####..#...
  .....##...

  Tile 1427:
  ###.##.#..
  .#..#.##..
  .#.##.#..#
  #.#.#.##.#
  ....#...##
  ...##..##.
  ...#.#####
  .#.####.#.
  ..#..###.#
  ..##.#..#.

  Tile 1489:
  ##.#.#....
  ..##...#..
  .##..##...
  ..#...#...
  #####...#.
  #..#.#.#.#
  ...#.#.#..
  ##.#...##.
  ..##.##.##
  ###.##.#..

  Tile 2473:
  #....####.
  #..#.##...
  #.##..#...
  ######.#.#
  .#...#.#.#
  .#########
  .###.#..#.
  ########.#
  ##...##.#.
  ..###.#.#.

  Tile 2971:
  ..#.#....#
  #...###...
  #.#.###...
  ##.##..#..
  .#####..##
  .#..####.#
  #..#.#..#.
  ..####.###
  ..#.#.###.
  ...#.#.#.#

  Tile 2729:
  ...#.#.#.#
  ####.#....
  ..#.#.....
  ....#..#.#
  .##..##.#.
  .#.####...
  ####.#.#..
  ##.####...
  ##..#.##..
  #.##...##.

  Tile 3079:
  #.#.#####.
  .#..######
  ..#.......
  ######....
  ####.#..#.
  .#...#.##.
  #.#####.##
  ..#.###...
  ..#.......
  ..#.###...
  """

  test "verify 2020/20 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file!(:part_one)
      |> Solution.parse_input!(:part_one)

    expected = 20_899_048_083_289
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/20 part_two - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 273
    assert expected == Solution.part_two(problem)
  end

  test "verify 2020/20 apply_transform" do
    input = [
      'ABCD',
      'EFGH'
    ]

    expected = [
      'DH',
      'CG',
      'BF',
      'AE'
    ]

    assert expected == Solution.apply_transform(input, {:rotate, -90})

    input = [
      'ABCD',
      'EFGH'
    ]

    expected = [
      'EA',
      'FB',
      'GC',
      'HD'
    ]

    assert expected == Solution.apply_transform(input, {:rotate, 90})
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 21_599_955_909_991

  test "verify 2020/20 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2020, 20, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 2495

  test "verify 2020/20 part two" do
    assert {:ok, @part_two_solution} == Aoe.run(2020, 20, :part_two)
  end
end
