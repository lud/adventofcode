defmodule AdventOfCode.Solutions.Y19.Day01Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y19.Day01, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  @part_one_solution 3_371_958

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 1, :part_one)
  end

  test "part two example" do
    input = ~S"""
    100756
    """

    assert 50346 == solve(input, :part_two)
  end

  # @part_two_solution 5_055_050
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2019, 1, :part_two)
  # end
end
