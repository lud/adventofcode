defmodule AdventOfCode.Solutions.Y19.Day17Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y19.Day17, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "alignment parameter" do
    {grid, _, _} =
      Solution.parse_grid("""
      ..#..........
      ..#..........
      #######...###
      #.#...#...#.#
      #############
      ..#...#...#..
      ..#####...^..
      """)

    assert 76 = Solution.aligment_parameter(grid)
  end

  @part_one_solution 3448
  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 17, :part_one)
  end

  @part_two_solution 762_405

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2019, 17, :part_two)
  end
end
