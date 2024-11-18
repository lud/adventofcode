defmodule AdventOfCode.Y15.Day19 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.read!(file)
  end

  def parse_input(input, _part) do
    [repls, start_molecule] = input |> String.trim() |> String.split("\n\n")
    repls = repls |> String.split("\n") |> Enum.map(&parse_replacement/1) |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    {repls, start_molecule}
  end

  defp parse_replacement(repl) do
    [from, to] = String.split(repl, " => ")
    {from, to}
  end

  def part_one({replacements, molecule}) do
    parts = split_molecule(molecule, replacements, [])

    reduce(parts, [], replacements, %{}) |> map_size()
  end

  defp reduce([h | t], prefix, replacements, results) when is_map_key(replacements, h) do
    results =
      replacements
      |> Map.fetch!(h)
      |> Enum.reduce(results, fn to, acc ->
        new_molecule = to_string([prefix, to, t])
        Map.put(acc, new_molecule, true)
      end)

    reduce(t, prefix ++ [h], replacements, results)
  end

  defp reduce([h | t], prefix, replacements, results) do
    reduce(t, prefix ++ [h], replacements, results)
  end

  defp reduce([], _, _, results) do
    results
  end

  defp split_molecule(<<>>, _replacements, parts) do
    :lists.reverse(parts)
  end

  defp split_molecule(molecule, replacements, parts) do
    found =
      Enum.find(replacements, fn {from, _tos} ->
        String.starts_with?(molecule, from)
      end)

    case found do
      {from, _} ->
        {^from, molecule} = String.split_at(molecule, String.length(from))
        split_molecule(molecule, replacements, [from | parts])

      nil ->
        {letter, molecule} = String.split_at(molecule, 1)
        split_molecule(molecule, replacements, [letter | parts])
    end
  end

  # def part_two(problem) do
  #   problem
  # end
end
