defmodule AdventOfCode.Solutions.Y24.Day23Test do
  alias AdventOfCode.Solutions.Y24.Day23, as: Solution
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
    kh-tc
    qp-kh
    de-cg
    ka-co
    yn-aq
    qp-ub
    cg-tb
    vc-aq
    tb-ka
    wh-tc
    yn-cg
    kh-ub
    ta-co
    de-co
    tc-td
    tb-wq
    wh-td
    ta-ka
    td-qp
    aq-cg
    wq-ub
    ub-vc
    de-ta
    wq-aq
    wq-vc
    wh-yn
    ka-de
    kh-ta
    co-tc
    wh-qp
    tb-vc
    td-yn
    """

    assert 7 == solve(input, :part_one)
  end

  @part_one_solution 1348

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 23, :part_one)
  end

  test "part two example" do
    input = ~S"""
    kh-tc
    qp-kh
    de-cg
    ka-co
    yn-aq
    qp-ub
    cg-tb
    vc-aq
    tb-ka
    wh-tc
    yn-cg
    kh-ub
    ta-co
    de-co
    tc-td
    tb-wq
    wh-td
    ta-ka
    td-qp
    aq-cg
    wq-ub
    ub-vc
    de-ta
    wq-aq
    wq-vc
    wh-yn
    ka-de
    kh-ta
    co-tc
    wh-qp
    tb-vc
    td-yn
    """

    assert "co,de,ka,ta" == solve(input, :part_two)
  end

  @part_two_solution "am,bv,ea,gh,is,iy,ml,nj,nl,no,om,tj,yv"
  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 23, :part_two)
  end
end
