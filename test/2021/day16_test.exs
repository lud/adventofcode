defmodule Aoe.Y21.Day16Test do
  use ExUnit.Case, async: true

  alias Aoe.Y21.Day16, as: Solution, warn: false
  alias Aoe.Input, warn: false
  import Solution

  # To run the test, run the following command:
  #
  #     mix test test/2021/day_16_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2021 --day 16 --part 1
  #
  # Use sample input:
  #
  #     {:ok, path} = Input.resolve(2021, 16, "sample-1")
  #

  @sample_1 """
  38006F45291200
  """

  test "decode litteral packet" do
    input = "D2FE28"
    decoded = Solution.decode_hex(input)
    assert pkt(vsn: 6, type: :lit, value: 2021) = decoded
  end

  test "decode sub packets" do
    input = "8A004A801A8002F478"

    decoded = Solution.decode_hex(input)

    assert pkt(
             vsn: 4,
             type: {:op, _},
             subs: [
               pkt(
                 vsn: 1,
                 type: {:op, _},
                 subs: [pkt(vsn: 5, type: {:op, _}, subs: [pkt(vsn: 6, type: :lit)])]
               )
             ]
           ) = decoded

    assert 16 == Solution.sum_versions(decoded)
  end

  test "verify 2021/16 part_one - samples" do
    # problem =
    #   @sample_1
    #   |> Input.as_file()
    #   |> Solution.read_file(:part_one)
    #   |> Solution.parse_input(:part_one)

    # expected = CHANGE_ME
    # assert expected == Solution.part_one(problem)
  end

  # test "verify 2021/16 part_two - samples" do
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

  @part_one_solution 877
  test "verify 2021/16 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2021, 16, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 194_435_634_456

  test "verify 2021/16 part two" do
    assert {:ok, @part_two_solution} == Aoe.run(2021, 16, :part_two)
  end
end
