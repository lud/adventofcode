defmodule AdventOfCode.Y15.Day7 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [input, output] = String.split(line, " -> ")
    {parse_sigin(input), parse_sigout(output)}
  end

  defp parse_sigin(inp) do
    case String.split(inp, " ") do
      [single] -> parse_val(single)
      [a, "AND", b] -> {:and, parse_val(a), parse_val(b)}
      [a, "OR", b] -> {:or, parse_val(a), parse_val(b)}
      [a, "LSHIFT", n] -> {:lshift, parse_val(a), parse_int(n)}
      [a, "RSHIFT", n] -> {:rshift, parse_val(a), parse_int(n)}
      ["NOT", a] -> {:not, parse_val(a)}
    end
  end

  defp parse_val(str) do
    case Integer.parse(str) do
      {int, ""} -> {:int, encode_int(int)}
      :error -> {:name, str}
    end
  end

  defp encode_int(int) do
    case :binary.encode_unsigned(int, :big) do
      <<c>> -> <<0, c>>
      <<_, _>> = two_bytes -> two_bytes
    end
  end

  defp parse_int(str) do
    {int, ""} = Integer.parse(str)
    int
  end

  defp parse_sigout(output) do
    parse_name(output)
  end

  defp parse_name(output) do
    case Integer.parse(output) do
      :error -> output
    end
  end

  def part_one(problem) do
    problem
    |> reduce([], %{})
    |> Map.fetch!("a")
    |> :binary.decode_unsigned()
  end

  def part_two(problem) do
    b_val = part_one(problem) |> :binary.encode_unsigned()

    problem =
      problem
      |> Enum.map(fn
        {{:int, _}, "b"} -> {{:int, b_val}, "b"}
        {inp, out} -> {inp, out}
      end)

    part_one(problem)
  end

  defp reduce([{inp, out} = wire | t], postponed, signals) do
    case build_sig(inp, signals) do
      :error ->
        reduce(t, [wire | postponed], signals)

      {:ok, val} ->
        signals = register(signals, out, val)
        reduce(t, postponed, signals)
    end
  end

  defp reduce([], [], signals) do
    signals
  end

  defp reduce([], postponed, signals) do
    reduce(postponed, [], signals)
  end

  defp register(signals, out, val) when not is_map_key(signals, out) do
    Map.put(signals, out, val)
  end

  defp fetch_val(_signals, {:int, n}) do
    {:ok, n}
  end

  defp fetch_val(signals, {:name, name}) do
    Map.fetch(signals, name)
  end

  defp build_sig({:int, <<_, _>> = n}, _signals) do
    {:ok, n}
  end

  defp build_sig({:name, _} = inp, signals) do
    fetch_val(signals, inp)
  end

  defp build_sig({:and, a, b}, signals) do
    with {:ok, va} <- fetch_val(signals, a),
         {:ok, vb} <- fetch_val(signals, b) do
      {:ok, band(va, vb)}
    end
  end

  defp build_sig({:or, a, b}, signals) do
    with {:ok, va} <- fetch_val(signals, a),
         {:ok, vb} <- fetch_val(signals, b) do
      {:ok, bor(va, vb)}
    end
  end

  defp build_sig({:lshift, a, n}, signals) do
    with {:ok, va} <- fetch_val(signals, a) do
      {:ok, lshift(va, n)}
    end
  end

  defp build_sig({:rshift, a, n}, signals) do
    with {:ok, va} <- fetch_val(signals, a) do
      {:ok, rshift(va, n)}
    end
  end

  defp build_sig({:not, a}, signals) do
    with {:ok, va} <- fetch_val(signals, a) do
      {:ok, bnot(va)}
    end
  end

  defp band(<<a, b>>, <<x, y>>) do
    <<Bitwise.band(a, x), Bitwise.band(b, y)>>
  end

  defp bor(<<a, b>>, <<x, y>>) do
    <<Bitwise.bor(a, x), Bitwise.bor(b, y)>>
  end

  defp bnot(<<a, b>>) do
    <<Bitwise.bnot(a), Bitwise.bnot(b)>>
  end

  # we describe the 16 bits as single bits
  defp lshift(int, 0), do: int

  defp lshift(int, z) do
    <<_::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1, j::1, k::1, l::1, m::1, n::1, o::1, p::1>> = int
    new = <<b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1, j::1, k::1, l::1, m::1, n::1, o::1, p::1, 0::1>>
    lshift(new, z - 1)
  end

  defp rshift(int, 0), do: int

  defp rshift(int, z) do
    <<a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1, j::1, k::1, l::1, m::1, n::1, o::1, _::1>> = int
    new = <<0::1, a::1, b::1, c::1, d::1, e::1, f::1, g::1, h::1, i::1, j::1, k::1, l::1, m::1, n::1, o::1>>
    rshift(new, z - 1)
  end

  # def part_two(problem) do
  #   problem
  # end
end
