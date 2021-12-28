defmodule Aoe.Y21.Day24 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(file, part) :: input
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(input, part) :: problem
  def parse_input!(input, _part) do
    Enum.map(input, &parse_statement/1)
  end

  defp parse_statement("inp " <> <<letter>>),
    do: {:inp, parse_letter(letter)}

  defp parse_statement("mul " <> args),
    do: stmt_2(:mul, args)

  defp parse_statement("add " <> args),
    do: stmt_2(:add, args)

  defp parse_statement("div " <> args),
    do: stmt_2(:div, args)

  defp parse_statement("eql " <> args),
    do: stmt_2(:eql, args)

  defp parse_statement("mod " <> args),
    do: stmt_2(:mod, args)

  defp stmt_2(instr, args) do
    {a, b} = take_args(args)
    {instr, a, b}
  end

  defp take_args(str) do
    str |> String.split(" ") |> Enum.map(&parse_arg/1) |> List.to_tuple()
  end

  defp parse_arg(<<letter>>) when letter in ?w..?z, do: parse_letter(letter)

  defp parse_arg(arg) do
    {int, ""} = Integer.parse(arg)
    int
  end

  defp parse_letter(?w), do: :w
  defp parse_letter(?x), do: :x
  defp parse_letter(?y), do: :y
  defp parse_letter(?z), do: :z

  defp monads do
    99_999_999_999_999
    |> Stream.iterate(fn num ->
      num - 1
    end)
    |> Stream.map(&Integer.digits/1)
    |> Stream.reject(&contains_0/1)
  end

  defp contains_0([0 | _]), do: true
  defp contains_0([_ | rest]), do: contains_0(rest)
  defp contains_0([]), do: false

  def part_one(program) do
    [
      # 99_999_999_999_999,
      # 99_999_999_999_998,
      # 99_999_999_999_997,
      # 99_999_999_999_996,
      # 99_999_999_999_995,
      # 99_999_999_999_994,
      99_999_999_995_893,
      99_999_999_985_893,
      99_999_999_975_893,
      99_999_999_965_893,
      99_999_999_955_893,
      99_999_999_945_893,
      99_999_999_935_893,
      99_999_999_925_893,
      99_999_999_915_893,
      99_999_999_995_893
      # 99_999_999_999_992,
      # 99_999_999_999_991
    ]
    |> Enum.map(&Integer.digits/1)
    # monads()
    # |> Stream.take(10)
    |> Enum.drop_while(fn digits ->
      IO.write("digits: #{Integer.undigits(digits)}")
      %{z: res} = run(program, digits)
      IO.puts(" => #{res}")
      res != 0
    end)
    |> Enum.take(1)

    # |> hd()
  end

  def part_two(program) do
    program
  end

  def run(program, buf) do
    run(program, buf, %{w: 0, x: 0, y: 0, z: 0})
  end

  def run([instr | rest], buf, state) do
    {buf, state} = call(instr, buf, state)
    # state |> IO.inspect(label: "state")
    run(rest, buf, state)
  end

  def run([], buf, state) do
    state
  end

  def putval(state, k, v) when k in ~w(w x y z)a,
    do: Map.put(state, k, v)

  def value(state, k) when k in ~w(w x y z)a,
    do: Map.fetch!(state, k)

  def value(state, int) when is_integer(int),
    do: int

  def call({:inp, a}, [b | buf], state),
    do: {buf, putval(state, a, b)}

  def call({:mul, a, b}, buf, state) do
    va = value(state, a)
    vb = value(state, b)
    {buf, putval(state, a, va * vb)}
  end

  def call({:add, a, b}, buf, state) do
    va = value(state, a)
    vb = value(state, b)
    {buf, putval(state, a, va + vb)}
  end

  def call({:mod, a, b}, buf, state) do
    va = value(state, a)
    vb = value(state, b)
    {buf, putval(state, a, rem(va, vb))}
  end

  def call({:div, a, b}, buf, state) do
    va = value(state, a)
    vb = value(state, b)
    {buf, putval(state, a, div(va, vb))}
  end

  def call({:eql, a, b}, buf, state) do
    va = value(state, a)
    vb = value(state, b)
    val = if va == vb, do: 1, else: 0
    {buf, putval(state, a, val)}
  end
end
