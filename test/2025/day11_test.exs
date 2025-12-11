defmodule AdventOfCode.Solutions.Y25.Day11Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y25.Day11, as: Solution, warn: false
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
    aaa: you hhh
    you: bbb ccc
    bbb: ddd eee
    ccc: ddd eee fff
    ddd: ggg
    eee: out
    fff: out
    ggg: out
    hhh: ccc fff iii
    iii: out
    """

    assert 5 == solve(input, :part_one)
  end

  @part_one_solution 511

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 11, :part_one)
  end

  test "part two example" do
    input = ~S"""
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
    """

    assert 2 == solve(input, :part_two)
  end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2025, 11, :part_two)
  # end
end
