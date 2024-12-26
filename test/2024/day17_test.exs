defmodule AdventOfCode.Solutions.Y24.Day17Test do
  alias AdventOfCode.Solutions.Y24.Day17, as: Solution
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
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """

    assert "4,6,3,5,6,3,5,2,1,0" == solve(input, :part_one)
  end

  defp state(overrides) do
    Map.merge(%{a: nil, b: nil, c: nil, stdout: []}, Map.new(overrides))
  end

  test "mini 1" do
    # If register C contains 9, the program 2,6 would set register B to 1.
    assert {%{b: 1}, _} = Solution.run_once(Solution.parse_program("2,6"), state(c: 9), 0)
  end

  test "mini 2" do
    # If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
    assert {%{stdout: [0]} = state, _} = Solution.run_once(Solution.parse_program("5,0,5,1,5,4"), state(a: 10), 0)
    assert {%{stdout: [1, 0]} = state, _} = Solution.run_once(Solution.parse_program("5,0,5,1,5,4"), state, 2)
    assert {%{stdout: [2, 1, 0]} = _state, _} = Solution.run_once(Solution.parse_program("5,0,5,1,5,4"), state, 4)
  end

  test "mini 3" do
    # If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
    assert %{stdout: [0, 1, 3, 7, 7, 7, 7, 6, 5, 2, 4], a: 0} =
             Solution.run(Solution.parse_program("0,1,5,4,3,0"), state(a: 2024), 0)
  end

  test "mini 4" do
    # If register B contains 29, the program 1,7 would set register B to 26.
    assert {%{b: 26}, _} = Solution.run_once(Solution.parse_program("1,7"), state(b: 29), 0)
  end

  test "mini 5" do
    # If register B contains 2024 and register C contains 43690, the program 4,0
    # would set register B to 44354.
    assert %{b: 44354} = Solution.run(Solution.parse_program("4,0"), state(b: 2024, c: 43690), 0)
  end

  #

  @part_one_solution "6,7,5,2,1,3,5,1,7"

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 17, :part_one)
  end

  test "part two example" do
    input = ~S"""
    Register A: 2024
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    """

    assert 117_440 == solve(input, :part_two)
  end

  @part_two_solution 216_549_846_240_877

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 17, :part_two)
  end

  test "reddit input example" do
    input = ~S"""
    Register A: 12345678
    Register B: 0
    Register C: 0

    Program: 2,4,1,0,7,5,1,5,0,3,4,5,5,5,3,0
    """

    assert "6,0,4,5,4,5,2,0" == solve(input, :part_one)
    assert 202_797_954_918_051 == solve(input, :part_two)
  end
end
