defmodule AdventOfCode.Y23.Day12Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Y23.Day12, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 12
  #
  #     mix test test/2023/day12_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 12 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-12-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 12, "sample")
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

  test "count line" do
    assert 1 == Solution.count_line({~c"???.###", [1, 1, 3]})
    # assert 4 == Solution.count_line({~c".??..??...?##.", [1, 1, 3]})
    # assert 1 == Solution.count_line({~c"?#?#?#?#?#?#?#?", [1, 3, 1, 6]})
    # assert 1 == Solution.count_line({~c"????.#...#...", [4, 1, 1]})
    # assert 4 == Solution.count_line({~c"????.######..#####.", [1, 6, 5]})
    # assert 10 == Solution.count_line({~c"?###????????", [3, 2, 1]})
  end

  # test "part one example" do
  #   input = """
  #   ???.### 1,1,3
  #   .??..??...?##. 1,1,3
  #   ?#?#?#?#?#?#?#? 1,3,1,6
  #   ????.#...#... 4,1,1
  #   ????.######..#####. 1,6,5
  #   ?###???????? 3,2,1
  #   """

  #   assert 21 == solve(input, :part_one)
  # end

  # @part_one_solution 6958

  # test "part one solution" do
  #   assert {:ok, @part_one_solution} == AoC.run(2023, 12, :part_one)
  # end

  # test "part two example" do
  #   input = """
  #   ???.### 1,1,3
  #   .??..??...?##. 1,1,3
  #   ?#?#?#?#?#?#?#? 1,3,1,6
  #   ????.#...#... 4,1,1
  #   ????.######..#####. 1,6,5
  #   ?###???????? 3,2,1
  #   """

  #   assert 525_152 == solve(input, :part_two)
  # end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2023, 12, :part_two)
  # end
end
