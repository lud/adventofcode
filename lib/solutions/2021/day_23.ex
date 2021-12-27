defmodule Aoe.Y21.Day23 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.read!(file)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    "#############\n" <> input = input
    "#...........#\n" <> input = input
    <<"###", t1, "#", t2, "#", t3, "#", t4, "###\n", input::binary>> = input
    <<"  #", l1, "#", l2, "#", l3, "#", l4, _::binary>> = input

    %{
      {2, 1} => c2b(t1),
      {2, 2} => c2b(l1),
      {4, 1} => c2b(t2),
      {4, 2} => c2b(l2),
      {6, 1} => c2b(t3),
      {6, 2} => c2b(l3),
      {8, 1} => c2b(t4),
      {8, 2} => c2b(l4)
    }
  end

  defp c2b(x), do: :erlang.list_to_binary([x])

  def part_one(problem) do
    reduce([problem])
  end

  defp reduce(problem) do
  end

  def part_two(problem) do
    problem
  end
end
