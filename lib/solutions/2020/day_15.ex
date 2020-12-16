defmodule Aoe.Y20.Day15 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    file |> Input.read!() |> String.trim()
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part_one(problem) do
    problem
    |> Enum.with_index(1)
    |> init_state(%{last: nil})
    |> loop_turn(length(problem) + 1, 2020)
  end

  defp init_state([{n, turn} | ns], state) do
    state = put_number(state, n, turn)
    init_state(ns, state)
  end

  defp init_state([], state) do
    state
  end

  defp put_number(state, n, turn) do
    case state do
      %{^n => {prev, ante}} -> Map.merge(state, %{n => {turn, prev}, :last => n})
      %{^n => {prev}} -> Map.merge(state, %{n => {turn, prev}, :last => n})
      _ -> Map.merge(state, %{n => {turn}, :last => n})
    end
  end

  defp loop_turn(%{last: last} = state, turn, max_turn) when turn > max_turn do
    last
  end

  defp loop_turn(%{last: last} = state, turn, max_turn) do
    state =
      case state do
        # last number was only spoken once
        %{^last => {_}} -> put_number(state, 0, turn)
        %{^last => {prev, ante}} -> put_number(state, prev - ante, turn)
      end

    loop_turn(state, turn + 1, max_turn)
  end

  def part_two(problem) do
    problem
    |> Enum.with_index(1)
    |> init_state(%{last: nil})
    |> loop_turn(length(problem) + 1, 30_000_000)
  end
end
