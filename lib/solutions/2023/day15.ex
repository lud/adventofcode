defmodule AdventOfCode.Y23.Day15 do
  alias AoC.Input, warn: false

  def read_file(file, _part) do
    Input.read!(file) |> String.trim()
  end

  def parse_input(input, :part_one) do
    input |> String.split(",") |> Enum.map(&String.to_charlist/1)
  end

  def parse_input(input, :part_two) do
    input |> String.split(",") |> Enum.map(&parse_command/1)
  end

  defp parse_command(com) do
    if String.contains?(com, "-") do
      label = String.trim_trailing(com, "-")
      {hash(label), label, :-}
    else
      [label, value] = String.split(com, "=")
      value = String.to_integer(value)
      {hash(label), label, value}
    end
  end

  def part_one(problem) do
    problem |> Enum.map(&hash/1) |> Enum.sum() |> dbg()
  end

  defp hash(chars) when is_list(chars) do
    Enum.reduce(chars, 0, &hash_char/2)
  end

  defp hash(chars) when is_binary(chars) do
    hash(String.to_charlist(chars))
  end

  defp hash_char(char, init) do
    ((init + char) * 17) |> rem(256)
  end

  def part_two(problem) do
    boxes = Map.new(0..255, fn i -> {i, []} end)

    boxes =
      Enum.reduce(problem, boxes, fn com, boxes ->
        com |> IO.inspect(label: ~S/After/)
        boxes = run_command(com, boxes)
        print_boxes(boxes)
        boxes
      end)

    focusing_power(boxes)
  end

  defp focusing_power(boxes) do
    0..255
    |> Enum.reduce(0, fn i, acc ->
      lenses = Map.fetch!(boxes, i)
      acc + focusing_power(lenses, 1, i + 1)
    end)
  end

  defp focusing_power([{_, n} = lens | t], lens_i, box_val) do
    binding() |> IO.inspect(label: ~S/----------------binding()/)
    power = n * lens_i * box_val
    lens |> IO.inspect(label: ~S/lens/)
    power |> IO.inspect(label: ~S/power/)
    power + focusing_power(t, lens_i + 1, box_val)
  end

  defp focusing_power([], lens_i, box_val) do
    0
  end

  defp print_boxes(boxes) do
    boxes
    |> Map.to_list()
    |> Enum.sort()
    |> Enum.filter(fn
      {_, []} -> false
      _ -> true
    end)
    |> Enum.map(fn {i, contents} ->
      [
        "Box ",
        Integer.to_string(i),
        ": ",
        Enum.map(contents, fn {label, n} -> ["[", label, " ", Integer.to_string(n), "]"] end),
        "\n"
      ]
    end)
    |> IO.puts()

    boxes
  end

  defp run_command({box_i, _, _} = com, boxes) do
    box = Map.fetch!(boxes, box_i)
    box = runcom(com, box)
    boxes = Map.put(boxes, box_i, box)

    boxes
  end

  defp runcom({_, label, :-}, box) do
    rm_num(box, label)
  end

  defp runcom({_, label, n}, box) when is_integer(n) do
    box = set_num(box, label, n)
  end

  defp rm_num([{label, _n} | rest], label), do: rest
  defp rm_num([{other, n} | rest], label), do: [{other, n} | rm_num(rest, label)]
  defp rm_num([], _), do: []

  defp set_num([{label, _} | rest], label, n) do
    [{label, n} | rest]
  end

  defp set_num([{other, x} | rest], label, n) do
    [{other, x} | set_num(rest, label, n)]
  end

  defp set_num([], label, n) do
    [{label, n}]
  end
end
