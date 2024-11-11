defmodule AdventOfCode.Y20.Day21 do
  alias AoC.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %AoC.Input.TestInput{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  def read_file(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  def parse_input(input, _part) do
    input
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    [ingredients, allergens] = String.split(line, " (contains ")

    ingredients =
      ingredients
      |> String.split(" ")

    allergens =
      allergens
      |> String.replace(")", "")
      |> String.split(", ")

    {ingredients, allergens}
  end

  defp initial_data(problem) do
    allergens2containers =
      problem
      |> Enum.reduce(%{}, fn {ingredients, allergens}, acc ->
        Enum.reduce(allergens, acc, fn alg, acc ->
          ingredients_set = MapSet.new(ingredients)
          Map.update(acc, alg, ingredients_set, &MapSet.intersection(&1, ingredients_set))
        end)
      end)

    possible_containers =
      allergens2containers
      |> Enum.reduce(MapSet.new(), fn {_alg, ingrs}, acc ->
        MapSet.union(acc, ingrs)
      end)

    all_ingredients =
      problem
      |> Enum.reduce(MapSet.new(), fn {ingredients, _}, acc ->
        MapSet.union(acc, MapSet.new(ingredients))
      end)

    no_allergens = MapSet.difference(all_ingredients, possible_containers)
    {allergens2containers, no_allergens}
  end

  def part_one(problem) do
    {_allergens2containers, no_allergens} = initial_data(problem)

    problem
    |> Enum.reduce(0, fn {ingredients, _}, acc ->
      Enum.reduce(ingredients, acc, fn ingr, acc ->
        if MapSet.member?(no_allergens, ingr) do
          acc + 1
        else
          acc
        end
      end)
    end)
  end

  def part_two(problem) do
    {allergens2containers, no_allergens} = initial_data(problem)
    allergens2containers = remove_safes(MapSet.to_list(no_allergens), allergens2containers)
    match_to_ingrs(allergens2containers, [])
  end

  defp match_to_ingrs(allergens2containers, acc) do
    case Enum.find(allergens2containers, fn {_alg, iset} -> MapSet.size(iset) == 1 end) do
      {alg, iset} ->
        [ingr] = MapSet.to_list(iset)
        acc = [{alg, ingr} | acc]

        allergens2containers =
          allergens2containers
          |> remove_for_all(ingr)
          |> Map.delete(alg)

        match_to_ingrs(allergens2containers, acc)

      nil ->
        acc
        |> Enum.sort()
        |> Keyword.values()
        |> Enum.join(",")
    end
  end

  defp remove_safes([safe | ingrs], allergens2containers) do
    remove_safes(ingrs, remove_for_all(allergens2containers, safe))
  end

  defp remove_safes([], allergens2containers) do
    allergens2containers
  end

  defp remove_for_all(allergens2containers, ingr) do
    Enum.map(allergens2containers, fn {alg, iset} -> {alg, MapSet.delete(iset, ingr)} end)
    |> Map.new()
  end
end
