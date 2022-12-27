defmodule Aoe.Y21.Day18 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    # Input.read!(file)
    Input.stream!(file, trim: true)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    input
    |> Stream.map(&String.replace(&1, "[", "{"))
    |> Stream.map(&String.replace(&1, "]", "}"))
    # |> Stream.map(&IO.inspect/1)
    |> Enum.map(&Code.string_to_quoted!(&1))
    |> Enum.map(&add_indices(&1))
  end

  defp add_indices(nums) do
    {nums, _} = add_indices(nums, -1)
    nums
  end

  defp add_indices(n, prev) when is_integer(n) do
    index = prev + 1
    {{:num, n, index}, index}
  end

  defp add_indices({a, b}, prev) do
    {a, prev} = add_indices(a, prev)
    {b, prev} = add_indices(b, prev)
    {{a, b}, prev}
  end

  def part_one(numbers) do
    # numbers |> Enum.each(&IO.puts(format(&1)))
    final_num = add_all(numbers)
    # IO.puts("final: #{format(final_num)}")
    magnitude(final_num)
    # numbers |> add_all() |> magnitude()
  end

  def part_two(numbers) do
    for a <- numbers, b <- numbers, a != b, reduce: 0 do
      man_max ->
        man1 = add_num(a, b) |> redux() |> magnitude()
        man2 = add_num(b, a) |> redux() |> magnitude()
        max(man_max, max(man1, man2))
    end
  end

  def magnitude({a, b}), do: 3 * magnitude(a) + 2 * magnitude(b)
  def magnitude({:num, v, _}), do: v

  def add_all(numbers) do
    Enum.reduce(numbers, fn right, left -> redux(add_num(left, right)) end)
  end

  def to_list({a, b}), do: [to_list(a), to_list(b)]
  def to_list({:num, v, _}), do: v

  defp format({a, b}) do
    [?[, format(a), ?,, format(b), ?]]
  end

  defp format({:num, n, i}) do
    # "#{i}: #{n}"
    Integer.to_string(n)
  end

  defp format_indices({a, b}) do
    [" ", format_indices(a), " ", format_indices(b), " "]
  end

  defp format_indices({:num, _, i}) do
    Integer.to_string(i)
  end

  defp redux(num) do
    # IO.puts("redux: #{format(num)}")

    case find_too_deep(num) do
      {:ok, index, vleft, vright} ->
        num = explode_at(num, index, vleft, vright)
        # IO.puts("exploded: #{format(num)}")
        redux(num)

      :error ->
        case find_split(num) do
          {:ok, index, value} ->
            num = split_at(num, index, value)
            # num |> IO.inspect(label: "splitted")
            # IO.puts("splitted: #{format(num)}")
            # IO.puts("        : #{format_indices(num)}")
            redux(num)

          :error ->
            num
        end
    end
  end

  defp add_num({a, b}, {x, y}) do
    max_i = max_index(b)
    {x, y} = offset_index({x, y}, max_i + 1)
    {{a, b}, {x, y}}
  end

  defp split_at(num, index, value) do
    num = offset_gte(num, index + 1, 1)
    {left, right} = {floor(value / 2), ceil(value / 2)}

    fmap(num, fn
      {:num, ^value, ^index} -> {{:num, left, index}, {:num, right, index + 1}}
      other -> other
    end)
  end

  defp max_index({a, b}), do: max_index(b)
  defp max_index({:num, _, i}), do: i

  defp offset_index(num, offset) do
    fmap(num, fn {:num, v, i} -> {:num, v, i + offset} end)
  end

  defp offset_gte(num, min_index, offset) do
    fmap(num, fn
      {:num, v, i} when i >= min_index -> {:num, v, i + offset}
      {:num, v, i} = n -> n
    end)
  end

  defp fmap({a, b}, f), do: {fmap(a, f), fmap(b, f)}
  defp fmap({:num, _, _} = n, f), do: f.(n)

  defp explode_at(num, index, vleft, vright) do
    num = if index > 0, do: add_to(num, index - 1, vleft), else: num
    num = add_to(num, index + 2, vright)
    _num = collapse_pair(num, index)
  end

  defp collapse_pair({{:num, _, index}, {:num, _, _}}, index) do
    {:num, 0, index}
  end

  defp collapse_pair({a, b}, index) do
    {collapse_pair(a, index), collapse_pair(b, index)}
  end

  defp collapse_pair({:num, v, i}, index) when i > index do
    {:num, v, i - 1}
  end

  defp collapse_pair({:num, _, _} = n, _) do
    n
  end

  defp add_to({:num, v, index}, index, to_add), do: {:num, v + to_add, index}
  defp add_to({:num, _, _} = n, _, _), do: n
  defp add_to({a, b}, index, to_add), do: {add_to(a, index, to_add), add_to(b, index, to_add)}

  defp find_too_deep(num) do
    find_too_deep(num, 0)
    :error
  catch
    {:too_deep, index, vleft, vright} -> {:ok, index, vleft, vright}
  end

  defp find_too_deep({{:num, vleft, index}, {:num, vright, _}}, dep) when dep >= 4 do
    throw({:too_deep, index, vleft, vright})
  end

  defp find_too_deep({a, b}, dep) do
    # {a, b} |> IO.inspect(label: "not too deep (#{dep})")
    find_too_deep(a, dep + 1)
    find_too_deep(b, dep + 1)
  end

  defp find_split(num) do
    fmap(num, fn {:num, v, i} ->
      if v >= 10 do
        throw({:splittable, v, i})
      end
    end)

    :error
  catch
    {:splittable, v, i} -> {:ok, i, v}
  end

  defp find_too_deep({:num, a, b}, _) do
    nil
  end

  defp index_of({:num, _, i}), do: i
  defp index_of({a, _b}), do: index_of(a)
end
