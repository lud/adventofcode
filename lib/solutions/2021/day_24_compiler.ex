defmodule D24Compiler do
  def transpile do
    code =
      "priv/input/2021/day-24.inp"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.filter(&(&1 != ""))
      |> Enum.map_reduce(0, &trans/2)
      |> elem(0)
      |> :lists.flatten()
      |> then(&(&1 ++ ["  z\nend\n"]))
      |> Enum.map_join("", &("  " <> &1))

    code = """
    defmodule AdventOfCode.Y21.Day24.Program do
      #{code}

      defp eql(same, same), do: 1
      defp eql(_, _), do: 0
    end
    """

    File.write!("lib/solutions/2021/day_24_program.ex", code)
    System.cmd("mix", ["format", "lib/solutions/2021/day_24_program.ex"])

    # |> Enum.join("\n")
  end

  def trans("inp " <> _var, n) do
    {[
       if n > 0 do
         "  z\nend\n"
       else
         []
       end,
       "def run(#{n}, w, z) do\n"
     ], n + 1}
  end

  def trans(line, n) do
    {"  " <> trans(line) <> "\n", n}
  end

  def trans("mul x 0"),
    do: "x = 0"

  def trans("mul y 0"),
    do: "y = 0"

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
