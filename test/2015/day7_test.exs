defmodule AdventOfCode.Solutions.Y15.Day7Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y15.Day7, as: Solution, warn: false
  use ExUnit.Case, async: true

  # To run the test, run one of the following commands:
  #
  #     mix AoC.test --year 2015 --day 7
  #
  #     mix test test/2015/day7_test.exs
  #
  # To run the solution
  #
  #     mix AoC.run --year 2015 --day 7 --part 1
  #
  # Use sample input file, for instance in priv/input/2015/"day-7-sample.inp"
  #
  #     {:ok, path} = Input.resolve(2015, 7, "sample")
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
    # Part one asks for value of wire `a` but the example does not give `a`. But
    # the example does give the value for all wires, so we will change each of
    # them to be `a`.

    make_input = fn a_name ->
      swap = fn original ->
        if original == a_name do
          "a"
        else
          original
        end
      end

      ~s"""
      123 -> #{swap.("x")}
      456 -> #{swap.("y")}
      #{swap.("x")} AND #{swap.("y")} -> #{swap.("d")}
      #{swap.("x")} OR #{swap.("y")} -> #{swap.("e")}
      #{swap.("x")} LSHIFT 2 -> #{swap.("f")}
      #{swap.("y")} RSHIFT 2 -> #{swap.("g")}
      NOT #{swap.("x")} -> #{swap.("h")}
      NOT #{swap.("y")} -> #{swap.("i")}
      """
    end

    expected = %{
      "d" => 72,
      "e" => 507,
      "f" => 492,
      "g" => 114,
      "h" => 65412,
      "i" => 65079,
      "x" => 123,
      "y" => 456
    }

    for a_name <- Map.keys(expected) do
      input = make_input.(a_name)
      assert Map.fetch!(expected, a_name) == solve(input, :part_one)
    end
  end

  @part_one_solution 16076

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2015, 7, :part_one)
  end

  @part_two_solution 2797

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2015, 7, :part_two)
  end
end
