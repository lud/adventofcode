defmodule D24Compiler do
  def transpile do

    "priv/input/2021/day-24.inp"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.filter(& &1 != "")
    |> Stream.map(&trans/1)
    # |> Stream.map(&IO.inspect/1)
    |> Enum.join("\n")
  end

  def trans("inp "<>var) do
    "[#{var}|buf] = buf"
  end
  def trans(<<"mul ", var, " ", value::binary>>) do
    var = <<var>>
    "#{var} = #{var} * #{value}"
  end
  def trans(<<"add ", var, " ", value::binary>>) do
    var = <<var>>
    "#{var} = #{var} + #{value}"
  end
  def trans(<<"mod ", var, " ", value::binary>>) do
    var = <<var>>
    "#{var} = rem(#{var}, #{value})"
  end
  def trans(<<"div ", var, " ", value::binary>>) do
    var = <<var>>
    "#{var} = div(#{var}, #{value})"
  end
  def trans(<<"eql ", var, " ", value::binary>>) do
    var = <<var>>
    "#{var} = eql(#{var}, #{value})"
  end
end

D24Compiler.transpile
|> IO.puts
