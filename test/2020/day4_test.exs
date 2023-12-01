defmodule Aoe.Y20.Day4Test do
  use ExUnit.Case, async: true

  alias Aoe.Y20.Day4, as: Solution, warn: false
  alias Aoe.Input, warn: false

  # To run the test, run the following command:
  #
  #     mix test test/2020/day_4_test.exs
  #
  # To run the solution
  #
  #     mix aoe.run --year 2020 --day 4 --part 1
  #
  # Use sample input: 
  #
  #     {:ok, path} = Input.resolve(2020, 4, "sample-1")
  #

  test "verify 2020/4 part_one - samples" do
    problem =
      """
      ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      byr:1937 iyr:2017 cid:147 hgt:183cm

      iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      hcl:#cfa07d byr:1929

      hcl:#ae17e1 iyr:2013
      eyr:2024
      ecl:brn pid:760753108 byr:1931
      hgt:179cm

      hcl:#cfa07d eyr:2025 pid:166559648
      iyr:2011 ecl:brn hgt:59in
      """
      |> Input.as_file()
      |> Solution.read_file!(:part_one)
      |> Solution.parse_input!(:part_one)

    expected = 2
    assert expected == Solution.part_one(problem)
  end

  test "verify 2020/4 part_two - invalid samples" do
    problem =
      """
      eyr:1972 cid:100
      hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

      iyr:2019
      hcl:#602927 eyr:1967 hgt:170cm
      ecl:grn pid:012533040 byr:1946

      hcl:dab227 iyr:2012
      ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

      hgt:59cm ecl:zzz
      eyr:2038 hcl:74454a iyr:2023
      pid:3556412378 byr:2007
      """
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 0
    assert expected == Solution.part_two(problem)
  end

  test "verify 2020/4 part_two - valid samples" do
    problem =
      """
      pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
      hcl:#623a2f

      eyr:2029 ecl:blu cid:129 byr:1989
      iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

      hcl:#888785
      hgt:164cm byr:2001 iyr:2015 cid:88
      pid:545766238 ecl:hzl
      eyr:2022

      iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
      """
      |> Input.as_file()
      |> Solution.read_file!(:part_two)
      |> Solution.parse_input!(:part_two)

    expected = 4
    assert expected == Solution.part_two(problem)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 245

  test "verify 2020/4 part one" do
    assert {:ok, @part_one_solution} == Aoe.run(2020, 4, :part_one)
  end

  # You may also implement a test to validate the part two to ensure that you
  # did not broke your shared modules when implementing another problem.

  @part_two_solution 133

  test "verify 2020/4 part two" do
    assert {:ok, @part_two_solution} == Aoe.run(2020, 4, :part_two)
  end
end
