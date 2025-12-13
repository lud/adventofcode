defmodule AdventOfCode.IntCPU do
  @enforce_keys [
    :memory,

    # instruction pointer
    :ip,

    # boolean
    :halted,

    # function and buffer/state of IO handler
    :io
  ]
  defstruct @enforce_keys

  def from_input(input) do
    from_string(AoC.Input.read!(input))
  end

  def from_string(ints_str) do
    ints_str
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> new()
  end

  def new(ints) do
    memory = Map.new(Enum.with_index(ints), fn {v, addr} -> {addr, v} end)
    %__MODULE__{memory: memory, ip: 0, halted: false, io: {:__no_io__, []}}
  end

  def run(cpu, opts \\ []) do
    cpu =
      Enum.reduce(opts, cpu, fn {:io, {fun, buf}}, cpu when is_function(fun, 1) ->
        %{cpu | io: {fun, buf}}
      end)

    loop(cpu)
  end

  defp loop(%{halted: true} = cpu) do
    cpu
  end

  defp loop(cpu) do
    instr = read_instr(cpu)
    cpu = exec(instr, cpu)
    # dump(cpu)
    loop(cpu)
  end

  @op_add 1
  @op_mul 2
  @op_ioread 3
  @op_iowrite 4
  @op_halt 99

  defp read_instr(cpu) do
    op = deref(cpu)

    case op do
      @op_add -> {:add, read_ahead(cpu, 3)}
      @op_mul -> {:mul, read_ahead(cpu, 3)}
      @op_ioread -> {:ioread, read_ahead(cpu)}
      @op_iowrite -> {:iowrite, read_ahead(cpu)}
      @op_halt -> :halt
    end
  end

  def deref(cpu) do
    deref(cpu, cpu.ip)
  end

  def deref(cpu, addr) do
    %{memory: memory} = cpu
    Map.fetch!(memory, addr)
  end

  # reads 1 value _after_ the current pointer
  defp read_ahead(cpu) do
    %{memory: memory, ip: ip} = cpu
    Map.fetch!(memory, ip + 1)
  end

  # reads N values _after_ the current pointer
  defp read_ahead(cpu, amount) when is_integer(amount) do
    %{memory: memory, ip: ip} = cpu
    Enum.map(1..amount, fn n -> Map.fetch!(memory, ip + n) end)
  end

  # writes a value at the given address without moving the ip
  def write(cpu, addr, value) when is_integer(value) do
    %{memory: memory} = cpu
    %{cpu | memory: Map.put(memory, addr, value)}
  end

  defp ip_move(cpu, amount) do
    %{ip: ip} = cpu
    %{cpu | ip: ip + amount}
  end

  defp exec({:add, [a, b, c]}, cpu) do
    a = deref(cpu, a)
    b = deref(cpu, b)
    cpu = write(cpu, c, a + b)
    ip_move(cpu, 4)
  end

  defp exec({:mul, [a, b, c]}, cpu) do
    a = deref(cpu, a)
    b = deref(cpu, b)
    cpu = write(cpu, c, a * b)
    ip_move(cpu, 4)
  end

  defp exec({:ioread, addr}, cpu) do
    {val, cpu} = ioread(cpu)
    cpu = write(cpu, addr, val)
    ip_move(cpu, 2)
  end

  defp exec({:iowrite, addr}, cpu) do
    val = deref(cpu, addr)
    cpu = iowrite(cpu, val)
    ip_move(cpu, 2)
  end

  defp exec(:halt, cpu) do
    %{cpu | halted: true}
  end

  defp ioread(cpu) do
    %{io: {fun, buf}} = cpu
    {val, buf} = fun.({:input, buf})
    cpu = %{cpu | io: {fun, buf}}
    {val, cpu}
  end

  defp iowrite(cpu, val) do
    %{io: {fun, buf}} = cpu
    buf = fun.({:output, val, buf})
    %{cpu | io: {fun, buf}}
  end

  # defp dump(cpu) do
  #   IO.puts(inspect(cpu))
  #   # Process.sleep(50)
  #   cpu
  # end

  defimpl Inspect do
    def inspect(cpu, _) do
      %{memory: memory, ip: ip} = cpu
      keys = Map.keys(memory)
      {min_key, max_key} = Enum.min_max(keys)

      int_width = 8
      # max_val = Enum.max(Map.values(memory))
      # cond do
      #   max_val < 1000 -> 3
      #   max_val < 10000 -> 4
      #   max_val < 100_000 -> 5
      #   max_val < 1_000_000 -> 6
      # end + 2

      "\n\n" <>
        (min_key..max_key
         |> Stream.chunk_every(8)
         |> Enum.map(fn chunk ->
           [Enum.map_intersperse(chunk, " ", &format_int(Map.fetch!(memory, &1), &1, ip, int_width)), "\n"]
         end)
         |> IO.iodata_to_binary())
    end

    defp format_int(int, index, ip, width) do
      str = Integer.to_string(int)

      if ip == index do
        [IO.ANSI.inverse(), String.pad_leading("[#{str}]", width), IO.ANSI.inverse_off()]
      else
        String.pad_leading(str, width)
      end
    end
  end
end
