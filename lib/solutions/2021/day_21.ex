defmodule Aoe.Y21.Day21 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @outcomes for(r1 <- 1..3, r2 <- 1..3, r3 <- 1..3, do: r1 + r2 + r3) |> Enum.frequencies()
  @score_max 6

  defp outcomes, do: @outcomes

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.read!(file)
    # Input.stream!(file)
    # Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
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
    state = [{{start_1, 0}, {start_2, 0}, 1}]
    solve(state)
  end

  defp solve(state) do
    turn = Process.get(:turn, 1)
    Process.put(:turn, turn + 1)
    IO.puts("-------- TURN #{turn} ---------")


    Enum.flat_map(state, fn {p1, p2, chances} ->)
      play_turn(p1, p2, chances)

    end)




    {p1, p1_wins} = play_turn({p1})
    p2 = apply_wins(p2, p1_wins)

    IO.puts("-- after p1 played")
    p1_wins |> IO.inspect(label: "p1_wins")
    p1 |> IO.inspect(label: "p1")
    p2 |> IO.inspect(label: "p2")

    {p2, p2_wins} = play_turn(p2)
    p1 = apply_wins(p1, p2_wins)

    IO.puts("-- after p2 played")
    p2_wins |> IO.inspect(label: "p2_wins")
    p1 |> IO.inspect(label: "p1")
    p2 |> IO.inspect(label: "p2")

    # Process.sleep(1000)

    sum_p1 = p1 |> Map.values() |> Enum.sum()
    sum_p2 = p2 |> Map.values() |> Enum.sum()

    sum_p1 |> IO.inspect(label: "sum_p1")
    sum_p2 |> IO.inspect(label: "sum_p2")

    if Map.size(p1) > 1 || Map.size(p1) > 2 do
      solve(p1, p2)
    else
      {p1, p2}
    end
  end

  defp play_turn(player) do
    outcomes =
      for {{pos, score}, universes} <- player,
          d <- @outcomes do
        new_pos = add_pos(pos, d)
        new_score = score + new_pos
        # new_universes = universes
        {{new_pos, new_score}, universes}
      end
      |> Enum.reduce({%{win: 0}, 0}, fn {{new_pos, new_score}, new_universes},
                                        {new_player, count_wins} ->
        if new_score >= @score_max do
          {Map.update!(new_player, :win, &(&1 + new_universes)), count_wins + new_universes}
        else
          {Map.update(new_player, {new_pos, new_score}, new_universes, &(&1 + new_universes)),
           count_wins}
        end
      end)

    # {player, player_wins} =
    #   for {{pos, score}, universes} <- player,
    #       d <- 1..3,
    #       reduce: {%{win: player.win}, 0} do
    #     {new_player, count_wins} ->
    #       new_pos = add_pos(pos, d)
    #       new_score = score + new_pos
    #       new_universes = universes

    #       if new_score >= @score_max do
    #         {Map.update!(new_player, :win, &(&1 + new_universes)), count_wins + new_universes}
    #       else
    #         {Map.update(new_player, {new_pos, new_score}, new_universes, &(&1 + new_universes)),
    #          count_wins}
    #       end
    #   end
  end

  defp add_pos(pos, moves) do
    rem(pos + moves - 1, 10) + 1
  end

  defp apply_wins(map, wins) do
    map
    |> Map.map(fn
      {:win, v} -> v
      {{_, _}, univ} -> univ * 27
    end)

    # |> Map.filter(fn
    #   {:win, _} -> true
    #   {{_, _}, univ} -> univ > 0
    # end)
  end
end
