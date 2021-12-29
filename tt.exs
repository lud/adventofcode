defmodule D24Compiler do
  def transpile do
    "priv/input/2021/day-24.inp"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(&1 != ""))
    |> Enum.map_reduce(0, &trans/2)
    |> elem(0)
    |> :lists.flatten()
    |> then(&(&1 ++ ["  z\nend\n"]))
    |> IO.puts()

    # |> Enum.join("\n")
  end

  def trans("inp " <> var = line, n) do
    {[
       if n > 0 do
         "  z\nend\n"
       else
         []
       end,
       "def prog(#{n}, w, z) do\n"
     ], n + 1}
  end

  def trans(line, n) do
    {"  " <> trans(line) <> "\n", n}
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

D24Compiler.transpile()
|> IO.puts()
