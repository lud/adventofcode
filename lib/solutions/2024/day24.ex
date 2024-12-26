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
    |> Enum.filter(fn
      "#" <> _ -> false
      _ -> true
    end)
    |> Enum.map(fn line ->
      [in1, op, in2, "->", out] = String.split(line, " ")
      make_gate(out, op, in1, in2)
    end)
    |> Map.new()
  end

  def make_gate(out, op, in1, in2) do
    # sort input
    input1 = min(in1, in2)
    input2 = max(in1, in2)
    {out, {parse_op(op), input1, input2}}
  end

  defp parse_op("AND"), do: :AND
  defp parse_op("OR"), do: :OR
  defp parse_op("XOR"), do: :XOR

  def part_one({wires, gates}) do
    wires = simulate(Map.to_list(gates), wires)

    {z, _} = zstate(wires)
    z
  end

  defp simulate(gates, postpone \\ [], wires)

  defp simulate([h | t], postpone, wires) do
    {out, {op, in1, in2}} = h

    {wires, postpone} =
      case {Map.get(wires, in1), Map.get(wires, in2)} do
        {nil, _} -> {wires, [h | postpone]}
        {_, nil} -> {wires, [h | postpone]}
        {v1, v2} -> {Map.put(wires, out, gate(op, v1, v2)), postpone}
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

  defp zstate(wires) do
    wires
    |> Enum.split_with(fn
      {"z" <> _, _} -> true
      _ -> false
    end)
    |> case do
      {zs, others} ->
        z =
          zs
          |> Enum.sort_by(&elem(&1, 0), :desc)
          |> Enum.map(&elem(&1, 1))
          |> Integer.undigits(2)

        {z, Enum.frequencies(Enum.map(others, &elem(&1, 1)))}
    end
  end

  def part_two({_wires, gates}) do
    gates
    |> find_swappables()
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp find_swappables(gates) do
    Enum.reduce(gates, [], fn
      # First gate is considered valid

      {_, {:AND, "x00", "y00"}}, acc ->
        acc

      # AND gate should lead to an OR gate
      {out, {:AND, _, _}}, acc ->
        leads_to_or? =
          Enum.find_value(gates, fn
            {_, {:OR, ^out, _}} -> true
            {_, {:OR, _, ^out}} -> true
            _ -> false
          end)

        if leads_to_or?, do: acc, else: [out | acc]

      {out, {:OR, _, _}}, acc ->
        # OR pointing to Z output is invalid
        acc =
          case out do
            "z45" <> _ -> acc
            "z" <> _ -> [out | acc]
            _ -> acc
          end

        # OR into OR is invalid, the current computation should be directed
        # elsewhere.
        leads_to_or? =
          Enum.find_value(gates, fn
            {_, {:OR, ^out, _}} -> true
            {_, {:OR, _, ^out}} -> true
            _ -> false
          end)

        if leads_to_or?, do: [out | acc], else: acc

      {"z00", {:XOR, "x00", "y00"}}, acc ->
        acc

      # input XOR gate should be reused in another XOR
      {out, {:XOR, <<x1, _, _>>, <<x2, _, _>>}}, acc when x1 == ?x when x2 == ?x ->
        leads_to_xor? =
          Enum.find_value(gates, fn
            {_, {:XOR, ^out, _}} -> true
            {_, {:XOR, _, ^out}} -> true
            _ -> false
          end)

        if leads_to_xor?, do: acc, else: [out | acc]

      # other XOR gates should be redirected to output
      {"z" <> _out, {:XOR, _, _}}, acc ->
        acc

      {out, {:XOR, _, _}}, acc ->
        [out | acc]
    end)
  end

  # This was used to try to find the swaps by looking at a graph

  def write_mermaid(gates, path) do
    flowchart = generate_mermaid(gates)
    File.write!(path, flowchart)
  end

  def generate_mermaid(gates) do
    indent = "  "

    gates =
      gates
      |> Enum.map(fn {out, {op, in1, in2}} -> {out, {op, min(in1, in2), max(in1, in2)}} end)
      |> Enum.sort_by(fn {out, {_op, in1, in2}} -> {out, in1, in2} end)

    lines =
      Enum.flat_map(gates, fn {out, {op, in1, in2}} ->
        op_node_id = "#{op}-#{in1}-#{in2}"

        [
          "#{indent}#{in1}{#{in1}} --> #{op_node_id}[#{op}]\n",
          "#{indent}#{in2}{#{in2}} --> #{op_node_id}[#{op}]\n",
          "#{indent}#{op_node_id} --> #{out}{#{out}}\n"
        ]
      end)

    """
    flowchart TD
    #{lines}
    """
  end

  # This was used to try to use a correct adder to compare with the bad adder.
  # Other code was removed.

  def generate_gates(input_bits) do
    half_adder = [
      {"z00", {:XOR, "x00", "y00"}},
      {"c00", {:AND, "x00", "y00"}}
    ]

    for i <- 1..(input_bits - 1), reduce: half_adder do
      acc ->
        [
          {plug_name("a", i), {:XOR, plug_name("x", i), plug_name("y", i)}},
          {plug_name("z", i), {:XOR, plug_name("a", i), plug_name("c", i - 1)}},
          {plug_name("n", i), {:AND, plug_name("a", i), plug_name("c", i - 1)}},
          {plug_name("m", i), {:AND, plug_name("x", i), plug_name("y", i)}},
          {plug_name("c", i), {:OR, plug_name("m", i), plug_name("n", i)}} | acc
        ]
    end
    # Final carry out is the superior new bit

    |> List.keyreplace(
      plug_name("c", input_bits - 1),
      0,
      {plug_name("z", input_bits), {:OR, plug_name("m", input_bits - 1), plug_name("n", input_bits - 1)}}
    )
    |> Map.new()
  end

  defp plug_name(<<_>> = prefix, i) do
    prefix <> pad_num(i)
  end

  defp pad_num(i) do
    String.pad_leading(Integer.to_string(i), 2, "0")
  end
end
