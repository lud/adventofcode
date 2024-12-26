defmodule AdventOfCode.Solutions.Y24.Day03Test do
  alias AdventOfCode.Solutions.Y24.Day03, as: Solution
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
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

    assert 161 == solve(input, :part_one)
  end

  @part_one_solution 192_767_529

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 3, :part_one)
  end

  test "part two example" do
    input = ~S"""
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """

    assert 48 == solve(input, :part_two)
  end

  @part_two_solution 104_083_373

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 3, :part_two)
  end
end
