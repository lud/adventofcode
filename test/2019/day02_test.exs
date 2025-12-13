defmodule AdventOfCode.Solutions.Y19.Day02Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y19.Day02, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  @part_one_solution 3_765_464

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 2, :part_one)
  end

  @part_two_solution 7610

  @tag :skip
  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2019, 2, :part_two)
  end
end
