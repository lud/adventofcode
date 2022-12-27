defmodule Aoe.Y20.Day19 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.read!(file)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    [rules, candidates] = String.split(input, "\n\n")

    rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn rule, acc -> add_rule(rule, acc) end)

    candidates =
      candidates
      |> String.split("\n", trim: true)

    {rules, candidates}
  end

  defp add_rule(rule, acc) do
    [index, rule] = String.split(rule, ": ")
    index = String.to_integer(index)

    value =
      case rule do
        ~s("a") -> :a
        ~s("b") -> :b
        ints -> ints |> String.split(" | ") |> Enum.map(&{:group, parse_int_group(&1)})
      end

    Map.put(acc, index, value)
  end

  defp parse_int_group(group) do
    order =
      group
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {:order, order}
  end

  def part_one({rulemap, candidates}) do
    count_matches(rulemap, candidates)
  end

  defp count_matches(rulemap, candidates) do
    rule_zero = "^" <> assemble_rule(rulemap[0], rulemap) <> "$"

    rule_zero =
      rule_zero
      |> String.replace("(a|b)", "[ab]")
      |> String.replace("[ab][ab]", "[ab]{2}")

    re = Regex.compile!(rule_zero)

    candidates
    |> Enum.filter(&Regex.match?(re, &1))
    |> length
  end

  def part_two({rulemap, candidates}) do
    rulemap =
      rulemap
      |> Map.put(8, {:repeat, 42})
      |> Map.put(11, {:repeat, {42, 31}})

    count_matches(rulemap, candidates)
  end

  defp assemble_rule([{:group, single_group}], map) do
    assemble_rule(single_group, map)
  end

  defp assemble_rule([{:group, _} | _] = groups, map) do
    groups
    |> Enum.map(fn {:group, group} -> assemble_rule(group, map) end)
    |> Enum.join("|")
    |> wrap_parens
  end

  defp assemble_rule({:order, indexes}, map) do
    Enum.reduce(indexes, [], fn i, acc ->
      [assemble_rule(map[i], map) | acc]
    end)
    |> :lists.reverse()
    |> Enum.join()
  end

  defp assemble_rule({:repeat, n}, map) when is_integer(n) do
    rule = assemble_rule(map[n], map)
    rule <> "+"
  end

  defp assemble_rule({:repeat, {ileft, iright}}, map) do
    left = assemble_rule(map[ileft], map)
    right = assemble_rule(map[iright], map)
    # Here is the hackish part: we will use left/right  left{n}right{n} with
    # sufficient increments for the size of our inputs. 4 is ok for my input,
    # and 5 makes a "regex is too large" error
    for n <- 1..4 do
      left <> "{#{n}}" <> right <> "{#{n}}"
    end
    |> Enum.join("|")
    |> wrap_parens
  end

  defp assemble_rule(:a, _), do: "a"
  defp assemble_rule(:b, _), do: "b"

  defp wrap_parens(str) do
    "(" <> str <> ")"
  end
end
