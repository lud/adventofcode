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

  def part_two({wires, gates}) do
    # inputs range from x00 to x44, so 45 bits gates, with 46 bits output
    generated = generate_gates(45)
    # step_through(gates, generated, wires)
    # verify(gates, generated)
    gates
    |> find_swappables()
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp find_swappables_2(gates) do
    lookup =
      Enum.flat_map(gates, fn {_, {op, left, right}} ->
        [{left, op}, {right, op}]
      end)

    Enum.reduce(gates, [], fn {to, {op, left, right}}, acc ->
      case op do
        :AND ->
          if left != "x00" && right != "y00" && {to, :OR} not in lookup do
            [to | acc]
          else
            acc
          end

        :OR ->
          acc =
            case to do
              "z45" -> acc
              "z" <> _ -> [to | acc]
              _ -> acc
            end

          if {to, :OR} in lookup do
            [to | acc]
          else
            acc
          end

        :XOR ->
          if String.starts_with?(left, "x") || String.starts_with?(right, "x") do
            # We have an input XOR gate, it should be connected to another XOR
            # gate
            if left != "x00" && right != "y00" && {to, :XOR} not in lookup do
              [to | acc]
            else
              acc
            end
          else
            # second level XOR gate, should be connected to output
            if String.starts_with?(to, "z") do
              acc
            else
              [to | acc]
            end
          end
      end
    end)
  end

  defp find_swappables(gates) do
    Enum.reduce(gates, [], fn
      # First gate is considered valid

      {_, {:AND, "x00", "y00"}}, acc ->
        acc

      # AND gate should lead to an OR gate
      {out, {:AND, _, _}}, acc ->
        leads_to_OR? =
          Enum.find_value(gates, fn
            {_, {:OR, ^out, _}} -> true
            {_, {:OR, _, ^out}} -> true
            _ -> false
          end)

        if leads_to_OR?, do: acc, else: [out | acc]

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
        leads_to_OR? =
          Enum.find_value(gates, fn
            {_, {:OR, ^out, _}} -> true
            {_, {:OR, _, ^out}} -> true
            _ -> false
          end)

        if leads_to_OR?, do: [out | acc], else: acc

      {"z00", {:XOR, "x00", "y00"}}, acc ->
        acc

      # input XOR gate should be reused in another XOR
      {out, {:XOR, <<x1, _, _>>, <<x2, _, _>>}}, acc when x1 == ?x when x2 == ?x ->
        leads_to_OR? =
          Enum.find_value(gates, fn
            {_, {:XOR, ^out, _}} -> true
            {_, {:XOR, _, ^out}} -> true
            _ -> false
          end)

        if leads_to_OR?, do: acc, else: [out | acc]

      # other XOR gates should be redirected to output
      {"z" <> _out, {:XOR, _, _}}, acc ->
        acc

      {out, {:XOR, _, _}}, acc ->
        [out | acc]
    end)
  end

  defp verify(gates, generated) do
    {carry_0_bad, _} = verify_half_adder(gates)
    {"c00", _} = verify_half_adder(generated)

    Enum.reduce(1..2, %{"c00" => carry_0_bad}, fn i, mapping ->
      next_carry = verify_full(gates, i, generated, mapping)
      Map.put(mapping, plug_name("c", i), next_carry)
    end)
  end

  defp verify_half_adder(gates) do
    # OK in my input
    {:XOR, "x00", "y00"} = Map.fetch!(gates, "z00")
    {_carry_0, {:AND, "x00", "y00"}} = Enum.find(gates, fn {_k, v} -> v == {:AND, "x00", "y00"} end)
  end

  defp verify_full(gates, i, generated, renames) do
    # Find the "a"
    #
    # {plug_name("a", i), {:XOR, plug_name("x", i), plug_name("y", i)}},
    a_name =
      case lookup_key(gates, {:XOR, plug_name("x", i), plug_name("y", i)}) do
        nil -> raise "a not found"
        name -> name
      end

    prev_carry = Map.fetch!(renames, plug_name("c", i - 1))

    # find the next z
    #
    # {plug_name("z", i), {:XOR, plug_name("a", i), plug_name("c", i - 1)}},
    :ok =
      case(Map.fetch!(gates, plug_name("z", i))) do
        {:XOR, ^a_name, ^prev_carry} -> :ok
      end

    # find n
    #
    # {plug_name("n", i), {:AND, plug_name("a", i), plug_name("c", i - 1)}},
    n_name =
      case lookup_key(gates, {:AND, a_name, prev_carry}) do
        nil -> raise "n not found"
        name -> name
      end

    # find m
    #
    # {plug_name("m", i), {:AND, plug_name("x", i), plug_name("y", i)}},
    m_name =
      case lookup_key(gates, {:AND, plug_name("x", i), plug_name("y", i)}) do
        nil -> raise "m not found"
        name -> name
      end

    # find next carry
    #
    # {plug_name("c", i), {:OR, plug_name("m", i), plug_name("n", i)}} | acc
    carry_i =
      case lookup_key(gates, {:OR, m_name, n_name}) do
        nil -> raise "carry #{i} not found"
        name -> name
      end

    carry_i
  end

  defp lookup_key(gates, value) do
    Enum.find_value(gates, fn
      {k, ^value} -> k
      _ -> nil
    end)
  end

  defp step_through(gates, generated, wires) do
    sorted_wires = Enum.sort(wires)
    # remove all x inputs
    {ys, xs} =
      Enum.reduce(wires, {[], []}, fn
        {"x" <> _, bit} = x, {keep, xs} -> {keep, [x | xs]}
        {"y" <> _, bit} = y, {keep, xs} -> {[y | keep], xs}
      end)

    xs = Enum.sort(xs)

    gates_good = Map.to_list(generated)

    x_chunks =
      xs
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.chunk_by(fn {max_x_name, v} = inp ->
        xs_sim = Enum.take_while(xs, fn {x_name, _} -> x_name <= max_x_name end)
        wires_sim = Map.new(xs_sim ++ ys)
        {result_wires, _} = simulate_halt(gates_good, wires_sim)
        {z, _} = zstate(result_wires)
        z
      end)

    ys = Map.new(ys)

    all_names = Map.keys(gates)

    prev_applied_gates = [[], []]
    found_swaps = []

    Enum.reduce(x_chunks, {gates, ys, prev_applied_gates, found_swaps}, fn
      input_chunk, {gates_bad, input_wires, all_prev, found_swaps} ->
        input_wires = Map.merge(input_wires, Map.new(input_chunk))

        {wires_bad_result, applied} = simulate_halt(Map.to_list(gates_bad), input_wires)
        {wires_good_result, _} = simulate_halt(gates_good, input_wires)

        z_bad = zstate(wires_bad_result)
        z_good = zstate(wires_good_result)

        if z_bad == z_good do
          {gates_bad, input_wires, [applied | all_prev], found_swaps}
        else
          {a, b, new_gates_bad} = try_swap(input_wires, gates, applied, all_names, z_good)
          {new_gates_bad, input_wires, [applied | all_prev], [{a, b} | found_swaps]}
        end
    end)
  end

  defp simulate_halt(gates, wires) do
    simulate_halt(gates, _postpone = [], wires, _applied_gates = [], _something_was_applied? = false)
  end

  defp simulate_halt([h | t], postpone, wires, applied_gates, prev_applied?) do
    {out, {op, in1, in2}} = h

    {wires, postpone, applied_gates, applied?} =
      case {Map.get(wires, in1), Map.get(wires, in2)} do
        {nil, _} ->
          {wires, [h | postpone], applied_gates, false}

        {_, nil} ->
          {wires, [h | postpone], applied_gates, false}

        {v1, v2} ->
          # v3 = gate(op, v1, v2)
          # IO.puts("value of #{out} = #{v3} ( #{v1} #{op} #{v2})")
          {Map.put(wires, out, gate(op, v1, v2)), postpone, [out | applied_gates], true}
      end

    simulate_halt(t, postpone, wires, applied_gates, prev_applied? or applied?)
  end

  defp simulate_halt([], [], wires, applied_gates, applied?) do
    {wires, applied_gates}
  end

  defp simulate_halt([], postpone, wires, applied_gates, applied?) do
    if applied? do
      simulate_halt(postpone, [], wires, applied_gates, false)
    else
      {wires, applied_gates}
    end
  end

  defp try_swap(wires, gates, swappables, all_names, expected_zstate) do
    combis = combinations(all_names, all_names)

    combis
    |> Enum.map(fn {a, b} -> {a, b, swap_gates(gates, a, b)} end)
    |> Enum.filter(fn {a, b, new_gates} ->
      {wires_result, _} = simulate_halt(Map.to_list(new_gates), wires)
      {z, _} = zstate = zstate(wires_result)

      case zstate do
        ^expected_zstate ->
          IO.puts("found swap #{a} / #{b} => #{inspect(zstate)}")
          true

        _ ->
          false
      end
    end)
    |> case do
      [{a, b, new_gates}] when is_map(new_gates) -> {a, b, new_gates}
      [{a, b, _}, {c, d, _}] -> "raise too many swaps : #{a} #{b} #{c} #{d}"
    end
  end

  defp swap_gates(gates, a, b) do
    {a_value, gates} = Map.pop!(gates, a)
    {b_value, gates} = Map.pop!(gates, b)

    Map.merge(gates, %{b => a_value, a => b_value})
  end

  defp combinations([h | t]) do
    for(sub <- t, do: {h, sub}) ++ combinations(t)
  end

  defp combinations([]) do
    []
  end

  defp combinations(swappables, all_names) do
    for a <- swappables, b <- all_names, a < b do
      {a, b}
    end
  end

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
