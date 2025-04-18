defmodule AdventOfCode.Solutions.Y23.Day20Test do
  alias AdventOfCode.Solutions.Y23.Day20, as: Solution
  alias AoC.Input
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 20
  #
  #     mix test test/2023/day20_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 20 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-20-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 20, "sample")
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
    input = ~S"""
    broadcaster -> a, b, c
    %a -> b
    %b -> c
    %c -> inv
    &inv -> a
    """

    assert 32_000_000 == solve(input, :part_one)
  end

  @part_one_solution 841_763_884

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 20, :part_one)
  end

  @part_two_solution 246_006_621_493_687

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 20, :part_two)
  end
end
