defmodule AdventOfCode.Solutions.Y25.Day08Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y25.Day08, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part, n_pairs) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem, n_pairs])
  end

  test "part one example" do
    input = ~S"""
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """

    assert 40 == solve(input, :part_one, 10)
    # flunk("oksofar")
  end

  @part_one_solution 57970
  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 8, :part_one)
  end

  # test "part two example" do
  #   input = ~S"""
  #   This is an
  #   example input.
  #   replace with
  #   an example from
  #   the AoC website.
  #   """
  #
  #   assert CHANGE_ME == solve(input, :part_two)
  # end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2025, 8, :part_two)
  # end
end
