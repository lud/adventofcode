defmodule AdventOfCode.Solutions.Y24.Day09Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day09, as: Solution, warn: false
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
    2333133121414131402
    """

    assert 1928 == solve(input, :part_one)
  end

  @part_one_solution 6_471_961_544_878

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 9, :part_one)
  end

  test "part two example" do
    input = ~S"""
    2333133121414131402
    """

    assert 2858 == solve(input, :part_two)
  end

  @part_two_solution 6_511_178_035_564

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 9, :part_two)
  end
end
