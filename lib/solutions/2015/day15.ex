defmodule AdventOfCode.Solutions.Y15.Day15 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Map.new(&parse_line/1)
  end

  def __atoms__,
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
    # In part one we add each teaspoon one by one, trying all possible
    # ingredients and keeping the composition that yields the best score.  This
    # is much more efficient than generating all possible permutations of the
    # ingredients as in part two.

    composition = Map.new(ingredients, fn {name, _} -> {name, 0} end) |> Map.put(:score, 0)

    # force each ingredient to be used at least once, otherwise their zero
    # values will make all scores to be zero, since we add each teaspoon one by
    # one.
    iterations = 100 - map_size(ingredients)
    composition = Map.new(composition, fn {name, _} -> {name, 1} end)

    best =
      Enum.reduce(1..iterations, composition, fn _i, best_comp ->
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
    # try to cook all possible cookies

    # we generate all permutions for N ingredients that add up to 100

    # we flat_map for the number of ingredients minus 2
    [_, _ | flatmap_count] = ingrnames = Map.keys(ingredients)

    # the first ingredient initialises the teaspoons permutation with a number
    # between 0 and 100, in a list
    stream = Stream.map(100..0//-1, &[&1])

    # then for each ingredient in the middle, we flat map the stream with 0 to
    # N-1 possible remaining teaspoons. This does not happen in the test example
    # as there are only two ingredients.
    stream =
      Enum.reduce(flatmap_count, stream, fn _, stream ->
        Stream.flat_map(stream, &permut_teaspoons/1)
      end)

    # for the last ingredient, we just add the remaining teaspoons so the sum is
    # 100
    stream = Stream.map(stream, &last_permut/1)

    # The we zip to get the composition and we cook the cookie. This could be in
    # the same Stream.map as the previous one but for clarity I separated them.
    # It does not change very much the performance.
    stream =
      Stream.map(stream, fn all_portions ->
        composition = Enum.zip(ingrnames, all_portions)
        cook(composition, ingredients)
      end)

    # Finally we filter the cookies that have 500 calories and we turn that into
    # scores.
    stream = Stream.filter(stream, fn cookie -> cookie.calories == 500 end)
    stream = Stream.map(stream, &cookie_score/1)

    # And we return the maximum score
    Enum.max(stream)
  end

  defp permut_teaspoons(used) do
    case Enum.sum(used) do
      100 -> [[0 | used]]
      n -> Stream.map(0..(100 - n), fn i -> [i | used] end)
    end
  end

  defp last_permut(used) do
    rest = 100 - Enum.sum(used)
    [rest | used]
  end
end
