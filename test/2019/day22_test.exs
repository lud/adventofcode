defmodule AdventOfCode.Y19.Day22Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y19.Day22, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2019/day22_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2019 --day 22 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2019, 22, "sample-1")
  #

  @part_one_solution 8326

  test "verify 2019/22 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 22, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2019/22 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2019, 22, :part_two)
  # end
end
