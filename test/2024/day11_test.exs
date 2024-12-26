defmodule AdventOfCode.Solutions.Y24.Day11Test do
  alias AdventOfCode.Solutions.Y24.Day11, as: Solution
  alias AoC.Input
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
    125 17
    """

    assert 55312 == solve(input, :part_one)
  end

  @part_one_solution 218_956

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 11, :part_one)
  end

  @part_two_solution 259_593_838_049_805

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 11, :part_two)
  end
end
