defmodule AdventOfCode.Solutions.Y24.Day25Test do
  alias AdventOfCode.Solutions.Y24.Day25, as: Solution, warn: false
  alias AoC.Input, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    #####
    .####
    .####
    .####
    .#.#.
    .#...
    .....

    #####
    ##.##
    .#.##
    ...##
    ...#.
    ...#.
    .....

    .....
    #....
    #....
    #...#
    #.#.#
    #.###
    #####

    .....
    .....
    #.#..
    ###..
    ###.#
    ###.#
    #####

    .....
    .....
    .....
    #....
    #.#..
    #.#.#
    #####
    """

    assert 3 == solve(input, :part_one)
  end

  @part_one_solution 3344

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 25, :part_one)
  end
end
