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
    p1 = %{{start_1, 0} => 1, :win => 0}
    p2 = %{{start_2, 0} => 1, :win => 0}
    solve(p1, p2)
  end

  defp solve(p1, p2) do
    %{win: add_p1_win} =
      new_p1 =
      for {{pos, score}, universes} <- p1, {moves, freq} <- outcomes(), reduce: %{win: 0} do
        new_p1 ->
          new_pos = add_pos(pos, moves)
          new_score = score + new_pos
          new_universes = universes * freq

          if new_score >= @score_max do
            Map.update!(new_p1, :win, &(&1 + new_universes))
          else
            Map.update(new_p1, {new_pos, new_score}, new_universes, &(&1 + new_universes))
          end
      end

    p1 = Map.update!(new_p1, :win, &(&1 + p1.win))

    p2 = apply_wins(p2, add_p1_win)

    IO.puts("after p1 played")
    p1 |> IO.inspect(label: "p1")
    p2 |> IO.inspect(label: "p2")

    %{win: add_p2_win} =
      new_p2 =
      for {{pos, score}, universes} <- p2, {moves, freq} <- outcomes(), reduce: %{win: 0} do
        new_p2 ->
          new_pos = add_pos(pos, moves)
          new_score = score + new_pos
          new_universes = universes * freq

          if new_score >= @score_max do
            Map.update!(new_p2, :win, &(&1 + new_universes))
          else
            Map.update(new_p2, {new_pos, new_score}, new_universes, &(&1 + new_universes))
          end
      end

    p2 = Map.update!(new_p2, :win, &(&1 + p2.win))
    p1 = apply_wins(p1, add_p2_win)

    IO.puts("after p2 played")
    p1 |> IO.inspect(label: "p1")
    p2 |> IO.inspect(label: "p2")

    sum_p1 = p1 |> Map.values() |> Enum.sum()
    sum_p2 = p2 |> Map.values() |> Enum.sum()

    if Map.size(p1) > 1 || Map.size(p1) > 2 do
      solve(p1, p2)
    else
      {p1, p2}
    end
  end

  defp add_pos(pos, moves) do
    rem(pos + moves - 1, 10) + 1
  end

  defp apply_wins(map, wins) do
    map
    |> Map.map(fn
      {:win, v} -> v * 27
      {{_, _}, univ} -> max(univ * 27 - wins, 0)
    end)
    |> Map.filter(fn
      {:win, _} -> true
      {{_, _}, univ} -> univ > 0
    end)
  end
end
