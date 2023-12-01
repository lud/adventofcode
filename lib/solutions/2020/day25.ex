defmodule Aoe.Y20.Day25 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.read!(file)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    [card_pubkey, door_pubkey] =
      input
      |> String.split("\n", parts: 2, trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    {card_pubkey, door_pubkey}
  end

  def part_one({card_pubkey, door_pubkey}) do
    card_ls = guess_loopsize(card_pubkey)
    create_key(door_pubkey, card_ls)
  end

  def part_two(problem) do
    problem
  end

  def magic_n, do: 7

  def create_pubkey(loop_size) do
    create_key(7, loop_size)
  end

  def create_key(subject, loop_size) do
    create_key(1, subject, loop_size)
  end

  defp create_key(value, _subject, 0) do
    value
  end

  defp create_key(value, subject, loop_size) do
    create_key(crypt_step(value, subject), subject, loop_size - 1)
  end

  def guess_loopsize(expected) do
    guess_loopsize(1, expected, magic_n(), 0)
  end

  def guess_loopsize(expected, subject) do
    guess_loopsize(1, expected, subject, 0)
  end

  defp guess_loopsize(expected, expected, _subject, loop_size) do
    loop_size
  end

  defp guess_loopsize(value, expected, subject, loop_size) do
    guess_loopsize(crypt_step(value, subject), expected, subject, loop_size + 1)
  end

  defp crypt_step(value, subject) do
    value = value * subject
    rem(value, 20_201_227)
  end
end
