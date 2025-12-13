defmodule AdventOfCode.IntCPU do
  @enforce_keys [:tape, :head, :halted]
  defstruct @enforce_keys

  def from_input(input) do
    from_string(AoC.Input.read!(input |> dbg()))
  end

  def from_string(ints_str) do
    ints_str
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> new()
  end

  def new(ints) do
    tape = Map.new(Enum.with_index(ints), fn {v, addr} -> {addr, v} end)
    %__MODULE__{tape: tape, head: 0, halted: false}
  end

  def run(cpu) do
    dump(cpu)
    loop(cpu)
  end

  defp loop(%{halted: true} = cpu) do
    cpu
  end

  defp loop(cpu) do
    {instr, cpu} = read_instr(cpu)
    cpu = exec(instr, cpu)
    dump(cpu)
    loop(cpu)
  end

  @op_add 1
  @op_mul 2
  @op_halt 99

  defp read_instr(cpu) do
    {op, cpu} = read(cpu)

    case op do
      @op_add ->
        {args, cpu} = read(cpu, 3)
        {{:add, pack(args)}, cpu}

      @op_mul ->
        {args, cpu} = read(cpu, 3)
        {{:mul, pack(args)}, cpu}

      @op_halt ->
        {:halt, cpu}
    end
  end

  # reads value at the current position and moves the head to the right
  defp read(cpu) do
    %{tape: tape, head: head} = cpu
    {Map.fetch!(tape, head), %{cpu | head: head + 1}}
  end

  # reads N values at the current position and moves the head to the right N
  # times
  defp read(cpu, amount) when is_integer(amount) do
    {data, cpu} = Enum.map_reduce(1..amount, cpu, fn _, cpu -> read(cpu) end)
    {data, cpu}
  end

  # reads a value without moving the head
  def deref(cpu, addr) do
    %{tape: tape} = cpu
    Map.fetch!(tape, addr)
  end

  # writes a value at the given address without moving the head
  def write(cpu, addr, value) when is_integer(value) do
    %{tape: tape} = cpu
    %{cpu | tape: Map.put(tape, addr, value)}
  end

  defp pack([a, b, c]), do: {a, b, c}

  defp exec({:add, {a, b, c}}, cpu) do
    a = deref(cpu, a)
    b = deref(cpu, b)
    write(cpu, c, a + b)
  end

  defp exec({:mul, {a, b, c}}, cpu) do
    a = deref(cpu, a)
    b = deref(cpu, b)
    write(cpu, c, a * b)
  end

  defp exec(:halt, cpu) do
    %{cpu | halted: true}
  end

  defp dump(cpu) do
    IO.puts(inspect(cpu))
    # Process.sleep(50)
    cpu
  end

  defimpl Inspect do
    def inspect(cpu, _) do
      %{tape: tape, head: head} = cpu
      keys = Map.keys(tape)
      {min_key, max_key} = Enum.min_max(keys)
      max_val = Enum.max(Map.values(tape))

      int_width = 8
      # cond do
      #   max_val < 1000 -> 3
      #   max_val < 10000 -> 4
      #   max_val < 100_000 -> 5
      #   max_val < 1_000_000 -> 6
      # end + 2

      min_key..max_key
      |> Stream.chunk_every(8)
      |> Enum.map(fn chunk ->
        [Enum.map_intersperse(chunk, " ", &format_int(Map.fetch!(tape, &1), &1, head, int_width)), "\n"]
      end)
      |> IO.iodata_to_binary()
    end

    defp format_int(int, index, head, width) do
      str = Integer.to_string(int)

      str =
        if head == index do
          [IO.ANSI.inverse(), String.pad_leading("[#{str}]", width), IO.ANSI.inverse_off()]
        else
          String.pad_leading(str, width)
        end
    end
  end
end
