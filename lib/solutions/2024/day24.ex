defmodule AdventOfCode.Solutions.Y24.Day24 do
  alias AoC.Input

  def parse(input, _part) do
    [wires, gates] = String.split(String.trim(Input.read!(input)), "\n\n")
    {parse_wires(wires), parse_gates(gates)}
  end

  defp parse_wires(lines) do
    lines
    |> String.split("\n")
    |> Enum.map(fn <<name::binary-size(3), ": ", v::8>> ->
      case v do
        ?1 -> {name, 1}
        ?0 -> {name, 0}
      end
    end)
    |> Map.new()
  end

  defp parse_gates(lines) do
    lines
    |> String.split("\n")
    |> Enum.map(fn
      <<gt1::binary-size(3), " OR ", gt2::binary-size(3), " -> ", gt3::binary-size(3)>> ->
        {gt3, {:OR, gt1, gt2}}

      <<gt1::binary-size(3), " AND ", gt2::binary-size(3), " -> ", gt3::binary-size(3)>> ->
        {gt3, {:AND, gt1, gt2}}

      <<gt1::binary-size(3), " XOR ", gt2::binary-size(3), " -> ", gt3::binary-size(3)>> ->
        {gt3, {:XOR, gt1, gt2}}
    end)
  end

  def part_one({wires, gates}) do
    wires = simulate(gates, wires)

    wires
    |> Enum.filter(fn
      {"z" <> _, _} -> true
      _ -> false
    end)
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.map(&elem(&1, 1))
    |> Integer.undigits(2)
  end

  defp simulate(gates, postpone \\ [], wires)

  defp simulate([h | t], postpone, wires) do
    {out, {op, in1, in2}} = h

    {wires, postpone} =
      case {Map.get(wires, in1), Map.get(wires, in2)} do
        {nil, _} ->
          {wires, [h | postpone]}

        {_, nil} ->
          {wires, [h | postpone]}

        {v1, v2} ->
          v3 = gate(op, v1, v2)
          IO.puts("value of #{out} = #{v3} ( #{v1} #{op} #{v2})")
          {Map.put(wires, out, gate(op, v1, v2)), postpone}
      end

    simulate(t, postpone, wires)
  end

  defp simulate([], [], wires) do
    wires
  end

  defp simulate([], postpone, wires) do
    simulate(postpone, [], wires)
  end

  defp gate(:OR, v1, v2), do: Bitwise.bor(v1, v2)
  defp gate(:AND, v1, v2), do: Bitwise.band(v1, v2)
  defp gate(:XOR, v1, v2), do: Bitwise.bxor(v1, v2)

  # def part_two(problem) do
  #   problem
  # end
end
