defmodule AdventOfCode.Y23.Day10Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day10, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 10
  #
  #     mix test test/2023/day10_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 10 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-10-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 10, "sample")
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
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """

    assert 8 === solve(input, :part_one)
  end

  test "part one bad search" do
    input = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """

    assert 8 === solve(input, :part_one)
  end

  test "part one correct path" do
    input = """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """

    assert 4 == solve(input, :part_one)
  end

  @part_one_solution 6682

  # test "part one solution" do
  #   assert {:ok, @part_one_solution} == AoC.run(2023, 10, :part_one)
  # end

  test "part two example" do
    input = """
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """

    assert 4 == solve(input, :part_two)
  end

  test "part two no space" do
    input = """
    ..........
    .S------7.
    .|F----7|.
    .||....||.
    .||....||.
    .|L-7F-J|.
    .|..||..|.
    .L--JL--J.
    ..........
    """

    assert 4 == solve(input, :part_two)
  end

  test "part two larger" do
    input = """
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    """

    assert 8 == solve(input, :part_two)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 353

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 10, :part_two)
  end
end
