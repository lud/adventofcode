defmodule AdventOfCode.Solutions.Y19.Day11Test do
  alias AoC.Input, warn: false
  alias AdventOfCode.Solutions.Y19.Day11, as: Solution, warn: false
  use ExUnit.Case, async: true

  @part_one_solution 2056

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2019, 11, :part_one)
  end

  @part_two_solution """
    ##  #    ###  #### ###    ## #### ###
   #  # #    #  # #    #  #    #    # #  #
   #    #    ###  ###  #  #    #   #  #  #
   # ## #    #  # #    ###     #  #   ###
   #  # #    #  # #    #    #  # #    #
    ### #### ###  #### #     ##  #### #\
  """

  test "part two solution" do
    assert {:ok, "\n" <> @part_two_solution} == AoC.run(2019, 11, :part_two)
  end
end
