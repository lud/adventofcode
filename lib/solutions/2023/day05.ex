defmodule AdventOfCode.Solutions.Y23.Day05 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    blocks = input |> String.trim_trailing() |> String.split("\n\n")

    [
      "seeds: " <> seeds_raw,
      "seed-to-soil map:\n" <> seed_to_soil_raw,
      "soil-to-fertilizer map:\n" <> soil_to_fertilizer_raw,
      "fertilizer-to-water map:\n" <> fertilizer_to_water_raw,
      "water-to-light map:\n" <> water_to_light_raw,
      "light-to-temperature map:\n" <> light_to_temperature_raw,
      "temperature-to-humidity map:\n" <> temperature_to_humidity_raw,
      "humidity-to-location map:\n" <> humidity_to_location_raw
    ] = blocks

    %{
      seeds: int_list(seeds_raw),
      seed_to_soil: parse_ranges(seed_to_soil_raw),
      soil_to_fertilizer: parse_ranges(soil_to_fertilizer_raw),
      fertilizer_to_water: parse_ranges(fertilizer_to_water_raw),
      water_to_light: parse_ranges(water_to_light_raw),
      light_to_temperature: parse_ranges(light_to_temperature_raw),
      temperature_to_humidity: parse_ranges(temperature_to_humidity_raw),
      humidity_to_location: parse_ranges(humidity_to_location_raw)
    }
  end

  defp int_list(line) do
    line |> String.split(" ") |> Enum.map(&String.to_integer/1)
  end

  defp parse_ranges(lines) do
    lines
    |> String.split("\n")
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(line) do
    [dest_0, source_0, len] = int_list(line)

    source_range = source_0..(source_0 + len - 1)//1
    dest_range = dest_0..(dest_0 + len - 1)//1
    {source_range, dest_range}
  end

  def part_one(problem) do
    locations = Enum.map(problem.seeds, &find_location(&1, problem))
    Enum.min(locations)
  end

  @path [
    :seed_to_soil,
    :soil_to_fertilizer,
    :fertilizer_to_water,
    :water_to_light,
    :light_to_temperature,
    :temperature_to_humidity,
    :humidity_to_location
  ]

  defp find_location(seed, data) do
    Enum.reduce(@path, seed, fn tl_key, id -> translate(Map.fetch!(data, tl_key), id) end)
  end

  defp translate(ranges, id) do
    case Enum.find(ranges, fn {source_range, _dest_range} -> id in source_range end) do
      {source_range, dest_range} ->
        diff = id - source_range.first
        dest_range.first + diff

      nil ->
        id
    end
  end

  def part_two(problem) do
    ranges =
      problem.seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [first, last] -> first..(first + last - 1) end)

    final_ranges = Enum.reduce(@path, ranges, &translate_ranges(Map.fetch!(problem, &1), &2))

    Enum.min_by(final_ranges, & &1.first).first
  end

  defp translate_ranges(mappers, ranges) do
    # For each mapper, split all the ranges into those that are covered by the
    # mapper source and those that are not. The latter can be consumed by the
    # next mapper and so on.
    #
    # Finally return the covered ranges translated by the mapper and the
    # leftover as-is, as they are valid ranges but map 1:1.

    Enum.flat_map_reduce(mappers, ranges, fn {source, _} = mapper, rest_ranges ->
      {covered_ranges, rest_ranges} = split_ranges(rest_ranges, source)
      {Enum.map(covered_ranges, &translate_range(&1, mapper)), rest_ranges}
    end)
    |> case do
      {translated, as_is} -> translated ++ as_is
    end
  end

  defp translate_range(range, {source, dest}) do
    diff = dest.first - source.first
    Range.shift(range, diff)
  end

  defp split_ranges(ranges, source) do
    split_ranges(ranges, source, {[], []})
  end

  defp split_ranges([r | ranges], source, {covered_ranges, rest_ranges}) do
    case split_range(r, source) do
      {nil, rest} ->
        split_ranges(ranges, source, {covered_ranges, rest ++ rest_ranges})

      {covered, nil} ->
        split_ranges(ranges, source, {covered ++ covered_ranges, rest_ranges})

      {covered, rest} ->
        split_ranges(ranges, source, {covered ++ covered_ranges, rest ++ rest_ranges})
    end
  end

  defp split_ranges([], _source, acc) do
    acc
  end

  def split_range(range, source)

  def split_range(ra.._rz//1 = range, _sa..sz//1) when sz < ra do
    {nil, [range]}
  end

  def split_range(_ra..rz//1 = range, sa.._sz//1) when sa > rz do
    {nil, [range]}
  end

  def split_range(ra..rz//1 = range, sa..sz//1) when sa <= ra and sz >= rz do
    {[range], nil}
  end

  def split_range(ra..rz//1, sa..sz//1) when sa >= ra and sz >= rz do
    {[sa..rz], [ra..(sa - 1)]}
  end

  def split_range(ra..rz//1, sa..sz//1) when sa <= ra and sz <= rz do
    {[ra..sz], [(sz + 1)..rz]}
  end

  def split_range(ra..rz//1, sa..sz//1) when sa >= ra and sz <= rz do
    {[sa..sz], [ra..(sa - 1), (sz + 1)..rz]}
  end
end
