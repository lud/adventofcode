defmodule Aoe.Y21.Day24Fail do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
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

  # defp monads do
  #   99_999_999_999_999
  #   |> Stream.iterate(fn num ->
  #     num - 1
  #   end)
  #   |> Stream.map(&Integer.digits/1)
  #   |> Stream.reject(&contains_0/1)
  # end

  # defp contains_0([0 | _]), do: true
  # defp contains_0([_ | rest]), do: contains_0(rest)
  # defp contains_0([]), do: false

  defp initial_state do
    %{
      # digit we operate on, from 0 to 13
      index: 13,
      digits: Integer.digits(99_999_999_999_999),
      best: 4_252_432_513
    }
  end

  def part_one(program) do
    reduce([initial_state()], program)
    # expand(initial_state(), program)
    # expand(%{index: 12, digits: Integer.digits(99_999_999_999_993), best: 163_555_096}, program)
    # expand(%{index: 11, digits: Integer.digits(99_999_999_999_993), best: 163_555_096}, program)
    # expand(%{index: 10, digits: Integer.digits(99_999_999_999_893), best: 163_555_091}, program)
    # expand(%{index: 13, digits: Integer.digits(99_999_999_999_899), best: 163_555_091}, program)
    # expand(%{index: 3, digits: Integer.digits(99_999_999_999_899), best: 163_555_091}, program)
    # expand(%{index: 09, digits: Integer.digits(99_999_999_995_893), best: 6_290_580}, program)
    # expand(%{index: 08, digits: Integer.digits(99_999_999_935_893), best: 241_945}, program)
    # expand(%{index: 07, digits: Integer.digits(99_999_999_935_893), best: 241_945}, program)
    # expand(%{index: 06, digits: Integer.digits(99_999_999_935_893), best: 241_945}, program)
    # expand(%{index: 05, digits: Integer.digits(99_999_999_935_893), best: 241_945}, program)
    # expand(%{index: 04, digits: Integer.digits(99_999_999_935_893), best: 241_945}, program)

    # # monads()
    # # |> Stream.take(10)
    # |> Enum.drop_while(fn digits ->
    #   IO.write("digits: #{Integer.undigits(digits)}")
    #   %{z: res} = run(program, digits)
    #   IO.puts(" => #{res}")
    #   res != 0
    # end)
    # |> Enum.take(1)

    # |> hd()
  end

  defp reduce([state | others], program) do
    case expand(state, program) do
      :deadend -> reduce(others, program)
      possibles -> reduce(possibles ++ others, program)
    end
  end

  defp expand(%{index: -1} = _state, _program) do
    :deadend
  end

  defp expand(%{digits: digits, index: index, best: best} = state, program) do
    index |> IO.inspect(label: "------------------ index")
    best |> IO.inspect(label: "best        ")

    1..9
    |> Enum.map(fn d ->
      digits = List.replace_at(digits, index, d)

      z = digits_to_z(digits, program)

      if z == 0 do
        throw({:win, digits})
      end

      # IO.puts("#{Integer.undigits(digits)} => #{z}")
      {z, d, digits}
    end)
    # |> IO.inspect(label: "got ")
    |> Enum.filter(fn {z, _, _} ->
      z <= best
    end)
    # |> IO.inspect(label: "kept")
    |> Enum.sort_by(fn {z, d, _digits} ->
      {z, -1 * d}
    end)
    # |> IO.inspect(label: "sorted")
    # |> Enum.map(&IO.inspect/1)
    |> case do
      [] ->
        :deadend

      [{least_z, _, _least_digits} | _] = possibles ->
        least_z |> IO.inspect(label: "least_z     ")

        # least_digits |> IO.inspect(label: "least_digits")

        # Process.sleep(1000)

        # if all_same_z(possibles, least_z) and least_z != 0 do
        #   # IO.puts("deadend at index #{index}: #{least_z}")
        #   :deadend
        # else
        possibles
        |> Enum.map(fn {z, _, new_digits} ->
          %{state | digits: new_digits, index: index - 1, best: z}
        end)

        # end
    end
  end

  # defp all_same_z([], _), do: true
  # defp all_same_z([{least, _, _} | rest], least), do: all_same_z(rest, least)
  # defp all_same_z([{other, _, _} | _rest], least) when other != least, do: false

  defp digits_to_z(digits, _program) do
    # %{z: z} = run(program, digits)
    # %{z: z} = run(program, digits)
    z = prog(digits)
    z
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

  def run([], [], state) do
    state
  end

  def putval(state, k, v) when k in ~w(w x y z)a,
    do: Map.put(state, k, v) |> IO.inspect(label: "state")

  def value(state, k) when k in ~w(w x y z)a,
    do: Map.fetch!(state, k)

  def value(_state, int) when is_integer(int),
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

  def prog(buf) do
    _w = 0
    x = 0
    y = 0
    z = 0
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 12
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 4
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 11
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 10
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 14
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 12
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -6
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 14
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 15
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 6
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 12
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 16
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -9
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 1
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 14
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 7
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 14
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 8
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -5
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 11
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -9
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 8
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -5
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 3
    y = y * x
    z = z + y
    [w | buf] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -2
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 1
    y = y * x
    z = z + y
    [w] = buf
    x = x * 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -7
    x = eql(x, w)
    x = eql(x, 0)
    y = y * 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = y * 0
    y = y + w
    y = y + 8
    y = y * x
    z = z + y
    z
  end

  defp eql(same, same), do: 1
  defp eql(_, _), do: 0
end
