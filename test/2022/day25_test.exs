defmodule AdventOfCode.Y22.Day25Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Y22.Day25, as: Solution, warn: false
  alias AoC.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2022/day_25_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2022 --day 25 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2022, 25, "sample-1")
  #

  @sample_1 """
  1=-0-2
  12111
  2=0=
  21
  2=01
  111
  20012
  112
  1=-1=
  1-12
  12
  1=
  122
  """

  test "parsing numbers" do
    assert Solution.parse_snafu("2=-01") == 976
    assert Solution.parse_snafu("1=-0-2") == 1747
    assert Solution.parse_snafu("12111") == 906
    assert Solution.parse_snafu("2=0=") == 198
    assert Solution.parse_snafu("21") == 11
    assert Solution.parse_snafu("2=01") == 201
    assert Solution.parse_snafu("111") == 31
    assert Solution.parse_snafu("20012") == 1257
    assert Solution.parse_snafu("112") == 32
    assert Solution.parse_snafu("1=-1=") == 353
    assert Solution.parse_snafu("1-12") == 107
    assert Solution.parse_snafu("12") == 7
    assert Solution.parse_snafu("1=") == 3
    assert Solution.parse_snafu("122") == 37
  end

  test "encoding numbers" do
    assert Solution.encode_snafu(8) == "2="
    assert Solution.encode_snafu(1) == "1"
    assert Solution.encode_snafu(2) == "2"
    assert Solution.encode_snafu(3) == "1="
    assert Solution.encode_snafu(4) == "1-"
    assert Solution.encode_snafu(5) == "10"
    assert Solution.encode_snafu(6) == "11"
    assert Solution.encode_snafu(314_159_265) == "1121-1110-1=0"
    assert Solution.encode_snafu(7) == "12"
    assert Solution.encode_snafu(9) == "2-"
    assert Solution.encode_snafu(10) == "20"
    assert Solution.encode_snafu(15) == "1=0"
    assert Solution.encode_snafu(20) == "1-0"
    assert Solution.encode_snafu(2022) == "1=11-2"
    assert Solution.encode_snafu(12345) == "1-0---0"
  end

  test "verify 2022/25 part_one - samples" do
    problem =
      @sample_1
      |> Input.as_file()
      |> Solution.read_file(:part_one)
      |> Solution.parse_input(:part_one)

    expected = "2=-1=0"
    assert expected == Solution.part_one(problem)
  end

  # test "verify 2022/25 part_two - samples" do
  #   problem =
  #     @sample_1
  #     |> Input.as_file()
  #     |> Solution.read_file(:part_two)
  #     |> Solution.parse_input(:part_two)
  #
  #   expected = CHANGE_ME
  #   assert expected == Solution.part_two(problem)
  # end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution "2-=2==00-0==2=022=10"

  test "verify 2022/25 part one" do
    assert {:ok, @part_one_solution} == AoC.run(2022, 25, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  # @part_two_solution CHANGE_ME
  #
  # test "verify 2022/25 part two" do
  #   assert {:ok, @part_two_solution} == AoC.run(2022, 25, :part_two)
  # end
end
