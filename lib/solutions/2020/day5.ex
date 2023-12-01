defmodule Aoe.Y20.Day5 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input(input, _part) do
    input
  end

  def part_one(problem) do
    problem
    |> Stream.map(&seat_id/1)
    |> Enum.max()
  end

  def part_two(problem) do
    problem
    |> Stream.map(&seat_id/1)
    |> Enum.sort()
    |> find_self_seat
  end

  def seat_id(letters) do
    partial = for <<char::8 <- letters>>, into: <<>>, do: cast_bit(char)
    :binary.decode_unsigned(<<0::6, partial::bitstring>>)
  end

  def cast_bit(?F), do: <<0::1>>
  def cast_bit(?L), do: <<0::1>>
  def cast_bit(?B), do: <<1::1>>
  def cast_bit(?R), do: <<1::1>>

  def find_self_seat([prev, next | _]) when next - prev == 2 do
    next - 1
  end

  def find_self_seat([_ | next]) do
    find_self_seat(next)
  end
end
