defmodule Aoe.Y20.Day22 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    {p2rev, p1rev} =
      input
      |> Enum.reduce({[], []}, fn
        "Player 1:", {[], []} = acc ->
          acc

        "Player 2:", {p1, []} ->
          {[], p1}

        nstr, {cur, other} ->
          {n, ""} = Integer.parse(nstr)
          {[n | cur], other}
      end)

    {:lists.reverse(p1rev), :lists.reverse(p2rev)}
  end

  def part_one({p1, p2}) do
    all = play_rounds(p1, p2)
    compute_score(all)
  end

  defp compute_score(cards) do
    cards
    |> :lists.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {card, index} -> card * index end)
    |> Enum.sum()
  end

  defp play_rounds([p1 | deck1], [p2 | deck2]) when p1 > p2 do
    play_rounds(deck1 ++ [p1, p2], deck2)
  end

  defp play_rounds([p1 | deck1], [p2 | deck2]) when p1 < p2 do
    play_rounds(deck1, deck2 ++ [p2, p1])
  end

  defp play_rounds([], all) do
    all
  end

  defp play_rounds(all, []) do
    all
  end

  def part_two({p1, p2}) do
    {_, cards} = play_rec(p1, p2, [], [])
    compute_score(cards)
  end

  defp play_rec([], cards2, _memo1, _memo2) do
    {:p2, cards2}
  end

  defp play_rec(cards1, [], _memo1, _memo2) do
    {:p1, cards1}
  end

  defp play_rec([c1 | rest1] = cards1, [c2 | rest2] = cards2, memo1, memo2) do
    if cards1 in memo1 or cards2 in memo2 do
      {:p1, cards1}
    else
      if c1 <= length(rest1) and c2 <= length(rest2) do
        case play_rec(Enum.take(rest1, c1), Enum.take(rest2, c2), [], []) do
          {:p1, _} -> play_rec(rest1 ++ [c1, c2], rest2, [cards1 | memo1], [cards2 | memo2])
          {:p2, _} -> play_rec(rest1, rest2 ++ [c2, c1], [cards1 | memo1], [cards2 | memo2])
        end
      else
        if c1 > c2 do
          play_rec(rest1 ++ [c1, c2], rest2, [cards1 | memo1], [cards2 | memo2])
        else
          play_rec(rest1, rest2 ++ [c2, c1], [cards1 | memo1], [cards2 | memo2])
        end
      end
    end
  end
end
