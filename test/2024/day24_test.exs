defmodule AdventOfCode.Solutions.Y24.Day24Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y24.Day24, as: Solution, warn: false
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
    x00: 1
    x01: 1
    x02: 1
    y00: 0
    y01: 1
    y02: 0

    x00 AND y00 -> z00
    x01 XOR y01 -> z01
    x02 OR y02 -> z02
    """

    assert 4 == solve(input, :part_one)
  end

  test "part one large" do
    input = ~S"""
    x00: 1
    x01: 0
    x02: 1
    x03: 1
    x04: 0
    y00: 1
    y01: 1
    y02: 1
    y03: 1
    y04: 1

    ntg XOR fgs -> mjb
    y02 OR x01 -> tnw
    kwq OR kpj -> z05
    x00 OR x03 -> fst
    tgd XOR rvg -> z01
    vdt OR tnw -> bfw
    bfw AND frj -> z10
    ffh OR nrd -> bqk
    y00 AND y03 -> djm
    y03 OR y00 -> psh
    bqk OR frj -> z08
    tnw OR fst -> frj
    gnj AND tgd -> z11
    bfw XOR mjb -> z00
    x03 OR x00 -> vdt
    gnj AND wpb -> z02
    x04 AND y00 -> kjc
    djm OR pbm -> qhw
    nrd AND vdt -> hwm
    kjc AND fst -> rvg
    y04 OR y02 -> fgs
    y01 AND x02 -> pbm
    ntg OR kjc -> kwq
    psh XOR fgs -> tgd
    qhw XOR tgd -> z09
    pbm OR djm -> kpj
    x03 XOR y03 -> ffh
    x00 XOR y04 -> ntg
    bfw OR bqk -> z06
    nrd XOR fgs -> wpb
    frj XOR qhw -> z04
    bqk OR frj -> z07
    y03 OR x01 -> nrd
    hwm AND bqk -> z03
    tgd XOR rvg -> z12
    tnw OR pbm -> gnj
    """

    assert 2024 == solve(input, :part_one)
  end

  @part_one_solution 46_463_754_151_024

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2024, 24, :part_one)
  end

  test "writing a correct adder" do
    # This is a correct 3 bits adder respecting the input format. It was written
    # by hand.
    #

    # adding  7 + 7 = 14 (0b111 + 0b111 = 0b1110)
    input = ~S"""
    x00: 1
    x01: 1
    x02: 1
    y00: 1
    y01: 1
    y02: 1

    # Half adder 0
    x00 XOR y00 -> z00
    y00 AND x00 -> c00
    # Full adder 1
    x01 XOR y01 -> a01
    a01 XOR c00 -> z01
    a01 AND c00 -> n01
    x01 AND y01 -> m01
    m01 OR n01 -> c01
    # Full adder 2
    x02 XOR y02 -> a02
    a02 XOR c01 -> z02
    a02 AND c01 -> n02
    x02 AND y02 -> m02
    # Final carry is the last bit
    m02 OR n02 -> z03
    """

    # We use part one to execute our adder
    assert 14 == solve(input, :part_one)

    # We will generate the same programmatically, following the same naming with
    # prefixed letters.
    #
    # The inputs are sorted during the parse, and the generator will also
    # generate sorted output.
    #
    # For instance in this input we have `y00 AND x00` but the parsed
    # representation has sorted it.

    {_inputs, expected_gates} =
      input
      |> Input.as_file()
      |> Solution.parse(:part_one)

    assert {:AND, "x00", "y00"} = Map.fetch!(expected_gates, "c00")
    Solution.write_mermaid(expected_gates, "tmp/2024-24-test.md")

    # Now with the generation

    generated_gates = Solution.generate_gates(_input_bits = 3)

    assert expected_gates == generated_gates
  end

  @part_two_solution "cqk,fph,gds,jrs,wrk,z15,z21,z34"

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2024, 24, :part_two)
  end
end
