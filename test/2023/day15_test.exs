defmodule AdventOfCode.Y23.Day15Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day15, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 15
  #
  #     mix test test/2023/day15_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 15 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-15-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 15, "sample")
  #
  # Good luck!

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.read_file(part)
      |> Solution.parse_input(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """

    assert 1320 == solve(input, :part_one)
  end

  @part_one_solution 515_210

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 15, :part_one)
  end

  test "part two example" do
    input = """
    rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
    """

    assert 145 == solve(input, :part_two)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2023, 15, :part_two)
  # end
end
