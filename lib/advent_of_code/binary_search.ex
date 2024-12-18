defmodule AdventOfCode.BinarySearch do
  def search(ask) do
    case ask.(0) do
      :eq -> 0
      :gt -> search(ask, search_min(ask, -1), 0)
      :lt -> search(ask, 0, search_max(ask, 1))
    end
  catch
    {:found, n} -> n
  end

  def search(_ask, min, max) when min > max do
    throw({:binary_search_tie, max, min})
  end

  def search(ask, min, max) when max == min + 1 do
    {min, max} |> IO.inspect(label: "{min,max}")

    n = div(min + max, 2)
    n |> IO.inspect(label: "n")

    case ask.(min) do
      :eq ->
        min

      :lt ->
        case ask.(max) do
          :eq -> max
          :gt -> throw({:binary_search_tie, min, max})
        end
    end
  end

  def search(ask, min, max) do
    {min, max} |> IO.inspect(label: "{min,max}")
    n = div(min + max, 2) |> dbg()

    case ask.(n) do
      # n is lower than the answer
      :lt -> search(ask, n + 1, max)
      # n is greater than the answer
      :gt -> search(ask, min, n - 1)
      :eq -> n
    end
  end

  defp search_min(ask, n) do
    # :lt means n is lower than the answer
    # :get means n is greater than the answer
    case ask.(n) do
      :gt -> search_min(ask, n * 2)
      :lt -> n
      :eq -> throw({:found, n})
    end
  end

  defp search_max(ask, n) do
    # :lt means n is lower than the answer
    # :get means n is greater than the answer
    case ask.(n) do
      :lt -> search_max(ask, n * 2)
      :gt -> n
      :eq -> throw({:found, n})
    end
  end
end
