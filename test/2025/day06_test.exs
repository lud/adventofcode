defmodule AdventOfCode.Solutions.Y25.Day06Test do
  alias AdventOfCode.Solutions.Y25.Day06, as: Solution, warn: false
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
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    """

    assert 4_277_556 == solve(input, :part_one)
  end

  @part_one_solution 5_060_053_676_136

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 6, :part_one)
  end

  test "part two example" do
    # Actual input is aligned on the right, so I changed the example to be
    # aligned on the right too. Makes everything simpler.
    #
    # Operators do not need to be aligned.

    input = ~S"""
    123 328  51  64
     45 64  387  23
      6 98  215 314
    *   +   *   +
    """

    assert 3_263_827 == solve(input, :part_two)
  end

  @part_two_solution 9_695_042_567_249

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2025, 6, :part_two)
  end
end
