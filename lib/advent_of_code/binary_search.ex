defmodule AdventOfCode.BinarySearch do
  def search(ask) do
    case ask.(0) do
      :eq -> {:ok, 0}
      :gt -> search(ask, search_min(ask, -1), 0)
      :lt -> search(ask, 0, search_max(ask, 1))
    end
  catch
    {:found, n} -> {:ok, n}
  end

  def search!(ask) do
    case search(ask) do
      {:ok, n} -> n
      {:error, tie} -> throw(tie)
    end
  end

  def search(_ask, min, max) when min > max do
    {:error, {:tie, max, min}}
  end

  def search(ask, min, max) do
    n = div(min + max, 2)

    case ask.(n) do
      # n is lower than the answer
      :lt -> search(ask, n + 1, max)
      # n is greater than the answer
      :gt -> search(ask, min, n - 1)
      :eq -> {:ok, n}
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
