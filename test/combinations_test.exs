defmodule AdventOfCode.CombinationsTest do
  alias AdventOfCode.Combinations
  use ExUnit.Case, async: true

  test "single" do
    assert [[:a]] = Combinations.of([:a], 1) |> Enum.to_list()
    assert [[:a], [:b]] = Combinations.of([:a, :b], 1) |> Enum.to_list()
  end

  test "two" do
    assert [[:a, :a]] = Combinations.of([:a], 2) |> Enum.to_list()

    # By default the combinations are ordered by iterating the leftmost element
    # first.
    assert [[:a, :a], [:b, :a], [:a, :b], [:b, :b]] = Combinations.of([:a, :b], 2) |> Enum.to_list()
  end

  test "tree" do
    assert [
             [:a, :a, :a],
             [:b, :a, :a],
             [:a, :b, :a],
             [:b, :b, :a],
             [:a, :a, :b],
             [:b, :a, :b],
             [:a, :b, :b],
             [:b, :b, :b]
           ] = Combinations.of([:a, :b], 3) |> Enum.to_list()

    assert [
             [:a, :a, :a],
             [:b, :a, :a],
             [:c, :a, :a],
             [:a, :b, :a],
             [:b, :b, :a],
             [:c, :b, :a],
             [:a, :c, :a],
             [:b, :c, :a],
             [:c, :c, :a],
             [:a, :a, :b],
             [:b, :a, :b],
             [:c, :a, :b],
             [:a, :b, :b],
             [:b, :b, :b],
             [:c, :b, :b],
             [:a, :c, :b],
             [:b, :c, :b],
             [:c, :c, :b],
             [:a, :a, :c],
             [:b, :a, :c],
             [:c, :a, :c],
             [:a, :b, :c],
             [:b, :b, :c],
             [:c, :b, :c],
             [:a, :c, :c],
             [:b, :c, :c],
             [:c, :c, :c]
           ] = Combinations.of([:a, :b, :c], 3) |> Enum.to_list()
  end
end
