defmodule AdventOfCode.Solutions.Y23.Day16Test do
  alias AdventOfCode.Solutions.Y23.Day16, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 16
  #
  #     mix test test/2023/day16_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 16 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-16-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 16, "sample")
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
    input = ~S"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """

    assert 46 == solve(input, :part_one)
  end

  @part_one_solution 7608

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 16, :part_one)
  end

  test "part two example" do
    input = ~S"""
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
    """

    assert 51 == solve(input, :part_two)
  end

  @part_two_solution 8221

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 16, :part_two)
  end
end
