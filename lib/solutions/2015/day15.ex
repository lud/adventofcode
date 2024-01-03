defmodule AdventOfCode.Y15.Day15 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Map.new(&parse_line/1)
  end

  def __atoms__(),
    do: [
      :calories
    ]

  defp parse_line(line) do
    [name, properties] = String.split(line, ": ")

    properties =
      properties
      |> String.split(", ")
      |> Map.new(fn pair ->
        [k, v] = String.split(pair, " ")
        {String.to_existing_atom(k), String.to_integer(v)}
      end)

    {name, properties}
  end

  def part_one(ingredients) do
    composition = Map.new(ingredients, fn {name, _} -> {name, 0} end) |> Map.put(:score, 0)

    # force each ingredient to be used at least once because of the 0 values

    iterations = 100 - map_size(ingredients)

    composition = Map.new(composition, fn {name, _} -> {name, 1} end)

    best =
      Enum.reduce(1..iterations, composition, fn i, best_comp ->
        ingredients
        |> Enum.map(fn {name, _} -> add_comp(best_comp, name, ingredients) end)
        |> Enum.max_by(& &1.score)
      end)

    best.score
  end

  defp add_comp(composition, name, ingredients) do
    composition = Map.update!(composition, name, &(&1 + 1))
    score = cook_and_score(composition, ingredients)
    Map.put(composition, :score, score)
  end

  defp cook_and_score(composition, ingredients) do
    cookie = cook(composition, ingredients)
    cookie_score(cookie)
  end

  defp cook(composition, ingredients) do
    init = %{
      capacity: 0,
      durability: 0,
      flavor: 0,
      texture: 0,
      calories: 0
    }

    Enum.reduce(composition, init, fn
      {:score, _}, acc ->
        acc

      {name, amount}, acc ->
        props = Map.fetch!(ingredients, name)

        Map.merge(acc, props, fn
          _, base, add -> base + amount * add
        end)
    end)
  end

  defp cookie_score(cookie) do
    %{
      capacity: c,
      durability: d,
      flavor: f,
      texture: t
    } = cookie

    max(0, c) * max(0, d) * max(0, f) * max(0, t)
  end

  def part_two(ingredients) do
    [_, _ | flatmap_count] = ingrnames = Map.keys(ingredients)
    stream = Stream.map(100..0, &[&1])

    stream =
      Enum.reduce(flatmap_count, stream, fn _, stream ->
        Stream.flat_map(stream, &permut_teaspoons/1)
      end)

    stream = Stream.map(stream, &last_permut/1)

    stream = Stream.map(stream, fn tsps -> Enum.zip(ingrnames, tsps) end)

    stream = Stream.map(stream, fn composition -> cook(composition, ingredients) end)

    stream = Stream.filter(stream, fn cookie -> cookie.calories == 500 end)

    stream = Stream.map(stream, &cookie_score/1)
    stream |> Enum.max()
  end

  defp permut_teaspoons(used) do
    case Enum.sum(used) do
      100 -> [[0 | used]]
      n -> Stream.map(1..(100 - n), fn i -> [i | used] end)
    end
  end

  defp last_permut(used) do
    rest = 100 - Enum.sum(used)
    [rest | used]
  end
end
