defmodule AdventOfCode.Solutions.Y23.Day19Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y23.Day19, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2023 --day 19
  #
  #     mix test test/2023/day19_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2023 --day 19 --part 1
  #
  # Use sample input file, for instance in priv/input/2023/"day-19-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2023, 19, "sample")
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
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
    """

    assert 19114 == solve(input, :part_one)
  end

  @part_one_solution 397_134

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2023, 19, :part_one)
  end

  test "part two example" do
    input = ~S"""
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
    """

    assert 167_409_079_868_000 == solve(input, :part_two)
  end

  @part_two_solution 127_517_902_575_337

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2023, 19, :part_two)
  end
end
