defmodule Aoe.Y20.Day16 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.read!(file)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    [rules, "your ticket:\n" <> ticket, "nearby tickets:\n" <> nearbies] =
      input |> String.trim() |> String.split("\n\n", parts: 3, trim: true)

    rules =
      rules
      |> String.split("\n")
      |> Enum.map(&parse_rule/1)

    ticket = parse_ticket(ticket)

    nearbies =
      nearbies
      |> String.split("\n")
      |> Enum.map(&parse_ticket/1)

    {rules, ticket, nearbies}
  end

  def parse_rule(rule) do
    [name, rest] = String.split(rule, ": ", parts: 2)

    [left, right] =
      rest
      |> String.split(" or ", parts: 2)
      |> Enum.map(&to_range/1)

    {name, left, right}
  end

  def parse_ticket(nums) do
    nums
    |> String.split(",")
    |> Input.list_of_integers()
  end

  def to_range(str) do
    [l, r] =
      str
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    l..r
  end

  def part_one({rules, _ticket, nearbies}) do
    nearbies
    |> Enum.reduce([], fn ntick, acc -> find_invalid_values(ntick, rules, acc) end)
    |> Enum.sum()
  end

  defp find_invalid_values(ticket, rules, acc) do
    Enum.reduce(ticket, acc, fn val, acc ->
      if Enum.any?(rules, &match_rule?(&1, val)) do
        acc
      else
        [val | acc]
      end
    end)
  end

  defp match_rule?({_name, left, right}, val) do
    cond do
      val in left -> true
      val in right -> true
      true -> false
    end
  end

  def part_two({rules, ticket, nearbies}) do
    nearbies = Enum.reject(nearbies, &has_invalid_values?(&1, rules))
    all = [ticket | nearbies]

    departure_idxs =
      all
      |> Enum.map(&Enum.with_index/1)
      |> :lists.flatten()
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Enum.map(&match_group_rules(&1, rules))
      |> reduce_groups([], %{})
      |> find_departures_indexes

    Enum.reduce(departure_idxs, 1, fn index, acc ->
      acc * Enum.at(ticket, index)
    end)
  end

  defp find_departures_indexes(map) do
    Enum.reduce(map, [], fn
      {index, "departure" <> _}, acc -> [index | acc]
      _, acc -> acc
    end)
  end

  defp reduce_groups([{index, names} = cur | groups], postponed, map) do
    if length(names) == 1 do
      [name] = names
      map = Map.put(map, index, name)
      groups = remove_name(groups ++ postponed, name)
      reduce_groups(groups, [], map)
    else
      reduce_groups(groups, [cur | postponed], map)
    end
  end

  defp reduce_groups([], [], map) do
    map
  end

  defp remove_name([{index, names} | groups], name) do
    [{index, names -- [name]} | remove_name(groups, name)]
  end

  defp remove_name([], _name) do
    []
  end

  defp match_group_rules({index, values}, rules) do
    names =
      rules
      |> Enum.filter(fn {_name, left, right} ->
        Enum.all?(values, fn v -> v in left or v in right end)
      end)
      |> Enum.map(&elem(&1, 0))

    {index, names}
  end

  defp has_invalid_values?(ticket, rules) do
    Enum.any?(ticket, fn val -> not Enum.any?(rules, &match_rule?(&1, val)) end)
  end
end
