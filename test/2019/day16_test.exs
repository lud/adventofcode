defmodule AdventOfCode.Solutions.Y19.Day16Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y19.Day16, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part, n_phases \\ 100) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem, n_phases])
  end

  test "get the nth_pattern element" do
    # get the 5 first digits to compute the first digit of the signal
    #
    # on first digit, pattern is the following (parenthesis show the skipped head
    # on first repetition)
    #
    #     (0),[1,0,-1,0,1],0,-1,0,1,0,-1,0,1,0,-1,
    #
    # So we should get 1,0,-1,0,1
    pattern_repeats = 1

    assert 1 = Solution.nth_pattern(1, pattern_repeats)
    assert 0 = Solution.nth_pattern(2, pattern_repeats)
    assert -1 = Solution.nth_pattern(3, pattern_repeats)
    assert 0 = Solution.nth_pattern(4, pattern_repeats)
    assert 1 = Solution.nth_pattern(5, pattern_repeats)

    # 5 first digits for the 2nd digit position, pattern is:
    #
    #     (0),[0,1,1,0,0],-1,-10,0,1,1,0,0,-1,-10,0,1,1,0,0,-1,-10,0,1,1,0,0,-1,-1
    pattern_repeats = 2

    assert 0 = Solution.nth_pattern(1, pattern_repeats)
    assert 1 = Solution.nth_pattern(2, pattern_repeats)
    assert 1 = Solution.nth_pattern(3, pattern_repeats)
    assert 0 = Solution.nth_pattern(4, pattern_repeats)
    assert 0 = Solution.nth_pattern(5, pattern_repeats)

    # 5 first digits for the 3rd digit position, pattern is:
    #
    # (0),[0,0,1,1,1],0,0,0,-1,-1,-1,0,0,0,1,1,1,0,0,0,-1,-1,-1,0,0,0,1,1,1,0,0,0,-
    pattern_repeats = 3

    assert 0 = Solution.nth_pattern(1, pattern_repeats)
    assert 0 = Solution.nth_pattern(2, pattern_repeats)
    assert 1 = Solution.nth_pattern(3, pattern_repeats)
    assert 1 = Solution.nth_pattern(4, pattern_repeats)
    assert 1 = Solution.nth_pattern(5, pattern_repeats)
  end

  test "get farther elements" do
    pattern_repeats = 1

    assert 1 = Solution.nth_pattern(1, pattern_repeats)
    assert 0 = Solution.nth_pattern(2, pattern_repeats)
    assert -1 = Solution.nth_pattern(3, pattern_repeats)
    assert 0 = Solution.nth_pattern(4, pattern_repeats)
    assert 1 = Solution.nth_pattern(5, pattern_repeats)
    assert 0 = Solution.nth_pattern(6, pattern_repeats)
    assert -1 = Solution.nth_pattern(7, pattern_repeats)
    assert 0 = Solution.nth_pattern(8, pattern_repeats)

    pattern_repeats = 2

    assert 0 = Solution.nth_pattern(1, pattern_repeats)
    assert 1 = Solution.nth_pattern(2, pattern_repeats)
    assert 1 = Solution.nth_pattern(3, pattern_repeats)
    assert 0 = Solution.nth_pattern(4, pattern_repeats)
    assert 0 = Solution.nth_pattern(5, pattern_repeats)
    assert -1 = Solution.nth_pattern(6, pattern_repeats)
    assert -1 = Solution.nth_pattern(7, pattern_repeats)
    assert 0 = Solution.nth_pattern(8, pattern_repeats)

    pattern_repeats = 3

    assert 0 = Solution.nth_pattern(1, pattern_repeats)
    assert 0 = Solution.nth_pattern(2, pattern_repeats)
    assert 1 = Solution.nth_pattern(3, pattern_repeats)
    assert 1 = Solution.nth_pattern(4, pattern_repeats)
    assert 1 = Solution.nth_pattern(5, pattern_repeats)
    assert 0 = Solution.nth_pattern(6, pattern_repeats)
    assert 0 = Solution.nth_pattern(7, pattern_repeats)
    assert 0 = Solution.nth_pattern(8, pattern_repeats)
  end

  test "basic test" do
    assert 01_029_498 = solve("12345678", :part_one, 4)
  end

  test "part one example" do
    assert 24_176_176 == solve("80871224585914546619083218645595", :part_one)
    assert 73_745_418 == solve("19617804207202209144916044189917", :part_one)
    assert 52_432_133 == solve("69317163492948606335995924319873", :part_one)
  end

  # test "does it repeat?" do
  #   assert 24_176_176 == solve("80871224585914546619083218645595", :part_one)
  # end

  @part_one_solution 68_764_632

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 16, :part_one)
  end

  @tag :skip
  test "part two example" do
    input = ~S"""
    03036732577212944063491565474664
    """

    assert 84_462_026 == solve(input, :part_two)
  end

  # @part_two_solution CHANGE_ME
  #
  # test "part two solution" do
  #   assert {:ok, @part_two_solution} == AoC.run(2019, 16, :part_two)
  # end
end
