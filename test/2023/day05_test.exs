defmodule AdventOfCode.Solutions.Y23.Day05Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y23.Day05, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 5
  #
  #     mix test test/2023/day5_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 5 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-5-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 5, "sample")
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
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    assert 35 == solve(input, :part_one)
  end

  test "part two example" do
    input = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    assert 46 == solve(input, :part_two)
  end

  test "split_range" do
    import Solution

    # no coverage
    assert {nil, [20..100]} = split_range(20..100, 0..10)
    assert {nil, [20..100]} = split_range(20..100, 999..1000)

    # source wraps the range
    assert {[20..100], nil} = split_range(20..100, 10..200)

    # source is exactly the range
    assert {[20..100], nil} = split_range(20..100, 20..100)

    # source wraps the range, with same first
    assert {[20..30], nil} = split_range(20..30, 20..999)

    # source wraps the range, with same last
    assert {[20..30], nil} = split_range(20..30, 0..30)

    # source overlaps the last boundary
    assert {[20..30], [10..19]} = split_range(10..30, 20..40)

    # source overlaps the last boundary with same first boundary
    assert {[10..30], nil} = split_range(10..30, 10..40)

    # source overlaps the first boundary
    assert {[10..20], [21..30]} = split_range(10..30, 0..20)

    # source overlaps the first boundary with same last boundary
    assert {[10..30], nil} = split_range(10..30, 0..30)

    # source is in the range
    assert {[20..30], [10..19, 31..40]} = split_range(10..40, 20..30)

    # source is in the range with same first boundary
    assert {[10..30], [31..40]} = split_range(10..40, 10..30)

    # source is in the range with same last boundary
    assert {[20..40], [10..19]} = split_range(10..40, 20..40)

    # source and range are length 1
    assert {[10..10], nil} = split_range(10..10, 10..10)
  end

  @part_one_solution 174_137_457

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 5, :part_one)
  end

  @part_two_solution 1_493_866

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 5, :part_two)
  end
end
