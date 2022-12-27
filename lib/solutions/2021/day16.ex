defmodule Aoe.Y21.Day16 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  require Record
  Record.defrecord(:pkt, vsn: nil, type: nil, subs: [], value: nil)

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.read!(file) |> String.trim()
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    decode_hex(input)
  end

  def part_one(pkt) do
    sum_versions(pkt)
  end

  def part_two(pkt) do
    eval(pkt)
  end

  defp eval(pkt(type: :lit, value: n)), do: n

  defp eval(pkt(type: {:op, op}, subs: subs)) when op in 0..3 do
    case op do
      0 -> subs |> Enum.map(&eval/1) |> Enum.sum()
      1 -> subs |> Enum.map(&eval/1) |> Enum.product()
      2 -> subs |> Enum.map(&eval/1) |> Enum.min()
      3 -> subs |> Enum.map(&eval/1) |> Enum.max()
    end
  end

  defp eval(pkt(type: {:op, op}, subs: [a, b])) do
    case op do
      5 -> if eval(a) > eval(b), do: 1, else: 0
      6 -> if eval(a) < eval(b), do: 1, else: 0
      7 -> if eval(a) == eval(b), do: 1, else: 0
    end
  end

  def sum_versions(pkt(type: :lit, vsn: vsn)), do: vsn
  def sum_versions(pkt(type: {:op, _}, vsn: vsn, subs: subs)), do: vsn + sum_versions(subs)
  def sum_versions([pkt() = p | rest]), do: sum_versions(p) + sum_versions(rest)
  def sum_versions([]), do: 0

  def decode_hex(hex) when is_binary(hex) do
    bin = Base.decode16!(hex)
    {p, zs} = decode_bin(bin)
    only0!(zs)
    p
  end

  defp only0!(<<0::1, rest::bitstring>>), do: only0!(rest)
  defp only0!(<<>>), do: :ok

  defp decode_bin(<<vsn::3, 4::3, rest::bitstring>>) do
    decode_lit(pkt(vsn: vsn, type: :lit), rest, 0)
  end

  defp decode_bin(<<
         vsn::3,
         op::3,
         0::1,
         sublen::15,
         subs::bitstring-size(sublen),
         rest::bitstring
       >>) do
    subs = decode_multi(subs)

    p = pkt(vsn: vsn, type: {:op, op}, subs: subs)
    {p, rest}
  end

  defp decode_bin(<<vsn::3, op::3, 1::1, subcount::11, rest::bitstring>>) do
    {subs, rest} = take_packets(rest, subcount, [])

    p = pkt(vsn: vsn, type: {:op, op}, subs: subs)
    {p, rest}
  end

  defp decode_lit(p, <<1::1, v::4, rest::bitstring>>, val) do
    decode_lit(p, rest, val * 16 + v)
  end

  defp decode_lit(p, <<0::1, v::4, rest::bitstring>>, val) do
    {pkt(p, value: val * 16 + v), rest}
  end

  defp decode_multi(bits) do
    decode_multi(bits, [])
  end

  defp decode_multi(bits, acc) do
    case decode_bin(bits) do
      {p, <<>>} -> :lists.reverse([p | acc])
      {p, rest} -> decode_multi(rest, [p | acc])
    end
  end

  defp take_packets(bits, n, acc) when n > 0 do
    {p, rest} = decode_bin(bits)
    take_packets(rest, n - 1, [p | acc])
  end

  defp take_packets(bits, 0, acc) do
    {:lists.reverse(acc), bits}
  end
end
