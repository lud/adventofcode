defmodule AdventOfCode.Solutions.Y19.Day07Test do
  alias AdventOfCode.Solutions.Y19.Day07, as: Solution, warn: false
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
    3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0
    """

    assert 43210 == solve(input, :part_one)
  end

  @part_one_solution 844_468

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 7, :part_one)
  end

  test "part two example" do
    input = ~S"""
    3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
    27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
    """

    assert 139_629_729 == solve(input, :part_two)
  end

  @part_two_solution 4_215_746

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2019, 7, :part_two)
  end
end
