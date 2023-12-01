defmodule Aoe.Y21.Day21 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @outcomes for(r1 <- 1..3, r2 <- 1..3, r3 <- 1..3, do: r1 + r2 + r3) |> Enum.frequencies()
  @score_max 21

  defp outcomes, do: @outcomes

  @spec read_file(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file(file, _part) do
    Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input(input, _part) do
    [
      "Player 1 starting position: " <> pl1,
      "Player 2 starting position: " <> pl2
    ] = input |> String.trim() |> String.split("\n")

    {String.to_integer(pl1), String.to_integer(pl2)}
  end

  # def part_one(problem) do
  #   problem
  # end

  def part_two({start_1, start_2}) do
    # {p1_state, p2_state, universes}
    state = [{{{start_1, 0}, {start_2, 0}}, 1}]
    wins = {0, 0}
    {p1, p2} = solve(state, wins)
    max(p1, p2)
  end

  defp solve(state, wins) do
    # turn = Process.get(:turn, 1)
    # Process.put(:turn, turn + 1)
    # IO.puts("-------- TURN #{turn} ---------")

    {state, wins} =
      Enum.flat_map(state, fn {{p1, p2}, univs} ->
        play_turn(p1, p2, univs)
      end)
      |> Enum.reduce({[], wins}, fn
        {{:win, _}, universes}, {state, {p1_wins, p2_wins}} ->
          {state, {p1_wins + universes, p2_wins}}

        {players, universes}, {state, wins} ->
          {[{players, universes} | state], wins}
      end)

    state =
      Enum.group_by(state, &elem(&1, 0), &elem(&1, 1))
      |> Enum.map(fn {k, v} -> {k, Enum.sum(v)} end)

    # state |> IO.inspect(label: "state")

    {state, wins} =
      Enum.flat_map(state, fn {{p1, p2}, univs} ->
        play_turn(p2, p1, univs) |> Enum.map(fn {{p2, p1}, univs} -> {{p1, p2}, univs} end)
      end)
      |> Enum.reduce({[], wins}, fn
        {{_, :win}, universes}, {state, {p1_wins, p2_wins}} ->
          {state, {p1_wins, p2_wins + universes}}

        {players, universes}, {state, wins} ->
          {[{players, universes} | state], wins}
      end)

    state =
      Enum.group_by(state, &elem(&1, 0), &elem(&1, 1))
      |> Enum.map(fn {k, v} -> {k, Enum.sum(v)} end)

    # state |> IO.inspect(label: "state")

    case state do
      [] -> wins
      _ -> solve(state, wins)
    end
  end

  defp play_turn({pos, score}, other_player, univs) do
    for {moves, freq} <- outcomes() do
      new_pos = add_pos(pos, moves)
      score = score + new_pos

      if score >= @score_max do
        {{:win, other_player}, univs * freq}
      else
        {{{new_pos, score}, other_player}, univs * freq}
      end
    end
  end

  defp add_pos(pos, moves) do
    rem(pos + moves - 1, 10) + 1
  end
end
