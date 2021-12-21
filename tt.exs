defmodule Day16AST do
  @moduledoc """
  Alternate solution for Day 16 using Elixir AST instead of %Packet{}
  """

  @path "priv/input/2021/day-16.inp"

  def solve do
    {ast, _} =
      @path
      |> File.read!()
      |> String.trim_trailing()
      |> Base.decode16!()
      |> make_ast()

    Macro.to_string(ast) |> IO.puts()

    Code.eval_quoted(ast)
  end

  defp make_ast(<<_version::3, 4::3, rest::bitstring>>) do
    {value, rest} = parse_literal(rest)
    pad_length = 8 - rem(bit_size(value), 8)
    literal = :binary.decode_unsigned(<<0::size(pad_length), value::bitstring>>)

    {literal, rest}
  end

  defp make_ast(
         <<_version::3, type_id::3, 0::1, len::15, values::bitstring-size(len), rest::bitstring>>
       ) do
    ast =
      values
      |> parse_values()
      |> ast_helper(type_id)

    {ast, rest}
  end

  defp make_ast(<<_version::3, type_id::3, 1::1, qty::11, rest::bitstring>>) do
    {values, rest} =
      Enum.reduce(1..qty, {[], rest}, fn _, {acc, rest} ->
        {ast, rest} = make_ast(rest)
        {[ast | acc], rest}
      end)

    ast =
      values
      |> Enum.reverse()
      |> ast_helper(type_id)

    {ast, rest}
  end

  defp parse_literal(value_bin, acc \\ <<>>)

  defp parse_literal(<<1::1, group::bitstring-size(4), rest::bitstring>>, acc) do
    parse_literal(rest, <<acc::bitstring, group::bitstring>>)
  end

  defp parse_literal(<<0::1, group::bitstring-size(4), rest::bitstring>>, acc) do
    {<<acc::bitstring, group::bitstring>>, rest}
  end

  defp parse_values(values_bin, acc \\ [])

  defp parse_values("", acc), do: Enum.reverse(acc)

  defp parse_values(values_bin, acc) do
    {ast, rest} = make_ast(values_bin)

    parse_values(rest, [ast | acc])
  end

  defp ast_helper(values, type_id) do
    case type_id do
      0 -> quote(do: Enum.sum(unquote(values)))
      1 -> quote(do: Enum.product(unquote(values)))
      2 -> quote(do: Enum.min(unquote(values)))
      3 -> quote(do: Enum.max(unquote(values)))
      5 -> ast_if(values, :>)
      6 -> ast_if(values, :<)
      7 -> ast_if(values, :==)
    end
  end

  defp ast_if([val_a, val_b], op) do
    quote do
      if unquote(op)(unquote(val_a), unquote(val_b)),
        do: 1,
        else: 0
    end
  end
end

Day16AST.solve()
|> IO.inspect(label: ~S[solved])
