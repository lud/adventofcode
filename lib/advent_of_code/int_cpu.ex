defmodule AdventOfCode.IntCPU do
  alias AdventOfCode.IntCPU.IOBuf

  @enforce_keys [
    :memory,

    # instruction pointer
    :ip,

    # boolean
    :halted,

    # function and buffer/state of IO handler
    :io,

    # addr offset for read with mode 2
    :relative_base
  ]
  defstruct @enforce_keys

  def from_input(input) do
    from_string(AoC.Input.read!(input))
  end

  def from_string(ints_str) do
    ints_str
    |> String.trim()
    |> String.replace(~r{\s}, "")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> new()
  end

  def new(ints) do
    memory = Map.new(Enum.with_index(ints), fn {v, addr} -> {addr, v} end)
    %__MODULE__{memory: memory, ip: 0, halted: false, io: :external_io, relative_base: 0}
  end

  def run(cpu, opts \\ []) do
    cpu =
      Enum.reduce(opts, cpu, fn
        {:io, fun}, cpu when is_function(fun, 1) ->
          %{cpu | io: {fun, fun.(:init)}}

        {:io, %IOBuf{} = buf}, cpu ->
          fun = IOBuf.as_fun(buf)

          %{cpu | io: {fun, fun.(:init)}}
      end)

    cpu |> IO.inspect(limit: :infinity, label: "cpu")
    loop(cpu)
  end

  defp suspend(tag, cpu, cont) do
    {:suspended, tag, cpu, cont}
  end

  def resume(cpu) do
    loop(cpu)
  end

  defp loop(cpu) do
    instr = read_instr(cpu)

    case exec(instr, cpu) do
      {:suspended, _, _, _} = sus -> maybe_auto_io(sus)
      {:halted, new_cpu} -> new_cpu
      %__MODULE__{} = new_cpu -> loop(new_cpu)
    end
  end

  defp maybe_auto_io({:suspended, :ioread, cpu, cont} = sus) do
    case cpu.io do
      :external_io ->
        sus

      {_, _} ->
        {val, cpu} = ioread(cpu)
        cpu = cont.(cpu, val)
        resume(cpu)
    end
  end

  defp maybe_auto_io({:suspended, {:iowrite, val}, cpu, cont} = sus) do
    case cpu.io do
      :external_io ->
        sus

      {_, _} ->
        cpu = iowrite(cpu, val)
        cpu = cont.(cpu)
        resume(cpu)
    end
  end

  def outputs(cpu) do
    case cpu do
      %{io: {_, %IOBuf{output: out}}} -> :lists.reverse(out)
      other -> raise "CPU does not hold an IOBuf IO state"
    end
  end

  @op_add 1
  @op_mul 2
  @op_ioread 3
  @op_iowrite 4
  @op_jumpt 5
  @op_jumpf 6
  @op_lt 7
  @op_eq 8
  @op_offset 9
  @op_halt 99

  # Parameter modes
  #
  # The rules use bad names on purpose to make everything unclear
  # "position" is "by ref", take the value at given address
  # "relative" is "by ref" + offset
  # "immediate" is "by value", just use the value as-is

  @mode_position 0
  @mode_immediate 1
  @mode_relative 2

  defp read_instr(cpu) do
    full_op = deref(cpu)
    {op, modes} = parse_modes(full_op)

    case op do
      @op_add -> {:add, with_modes(read_ahead(cpu, 3), modes)}
      @op_mul -> {:mul, with_modes(read_ahead(cpu, 3), modes)}
      @op_ioread -> {:ioread, with_modes(read_ahead(cpu), modes)}
      @op_iowrite -> {:iowrite, with_modes(read_ahead(cpu), modes)}
      @op_jumpt -> {:jumpt, with_modes(read_ahead(cpu, 2), modes)}
      @op_jumpf -> {:jumpf, with_modes(read_ahead(cpu, 2), modes)}
      @op_eq -> {:eq, with_modes(read_ahead(cpu, 3), modes)}
      @op_lt -> {:lt, with_modes(read_ahead(cpu, 3), modes)}
      @op_offset -> {:offset, with_modes(read_ahead(cpu), modes)}
      @op_halt -> :halt
      _ -> raise "unknown operation #{inspect(op)}"
    end
  end

  defp parse_modes(int) do
    op = rem(int, 100)
    mode1 = div(rem(int, 1000), 100)
    mode2 = div(rem(int, 10000), 1000)
    mode3 = div(rem(int, 100_000), 10000)
    {op, [mode1, mode2, mode3]}
  end

  defp with_modes([param | params], [mode | modes]) do
    [{param, mode} | with_modes(params, modes)]
  end

  defp with_modes([], _) do
    []
  end

  defp with_modes(n, [mode | _]) do
    {n, mode}
  end

  def deref(cpu) do
    deref(cpu, cpu.ip)
  end

  def deref(cpu, addr) when is_integer(addr) and addr >= 0 do
    %{memory: memory} = cpu
    Map.get(memory, addr, 0)
  end

  defp read_value(cpu, {addr, @mode_position}) do
    deref(cpu, addr)
  end

  defp read_value(_cpu, {value, @mode_immediate}) do
    value
  end

  defp read_value(cpu, {offset, @mode_relative}) do
    deref(cpu, cpu.relative_base + offset)
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
  def write(cpu, {addr, @mode_position}, value) when is_integer(value) do
    %{memory: memory} = cpu
    %{cpu | memory: Map.put(memory, addr, value)}
  end

  def write(cpu, {offset, @mode_relative}, value) when is_integer(value) do
    %{memory: memory, relative_base: base} = cpu
    %{cpu | memory: Map.put(memory, base + offset, value)}
  end

  def write(cpu, addr, value) when is_integer(value) and is_integer(addr) do
    write(cpu, {addr, @mode_position}, value)
  end

  defp move_ahead(cpu, amount) do
    %{ip: ip} = cpu
    %{cpu | ip: ip + amount}
  end

  defp move_to(cpu, addr) when is_integer(addr) do
    %{cpu | ip: addr}
  end

  defp exec({:add, [a, b, c]}, cpu) do
    a = read_value(cpu, a)
    b = read_value(cpu, b)
    cpu = write(cpu, c, a + b)
    move_ahead(cpu, 4)
  end

  defp exec({:mul, [a, b, c]}, cpu) do
    a = read_value(cpu, a)
    b = read_value(cpu, b)
    cpu = write(cpu, c, a * b)
    move_ahead(cpu, 4)
  end

  defp exec({:ioread, addr}, cpu) do
    suspend(:ioread, cpu, fn cpu, val ->
      cpu = write(cpu, addr, val)
      move_ahead(cpu, 2)
    end)
  end

  defp exec({:iowrite, addr}, cpu) do
    val = read_value(cpu, addr)
    suspend({:iowrite, val}, cpu, fn cpu -> move_ahead(cpu, 2) end)
  end

  defp exec({:jumpt, [a, b]}, cpu) do
    a = read_value(cpu, a)
    b = read_value(cpu, b)

    if a != 0 do
      move_to(cpu, b)
    else
      move_ahead(cpu, 3)
    end
  end

  defp exec({:jumpf, [a, b]}, cpu) do
    a = read_value(cpu, a)
    b = read_value(cpu, b)

    if a == 0 do
      move_to(cpu, b)
    else
      move_ahead(cpu, 3)
    end
  end

  defp exec({:lt, [a, b, c]}, cpu) do
    a = read_value(cpu, a)
    b = read_value(cpu, b)

    outval =
      if a < b do
        1
      else
        0
      end

    cpu = write(cpu, c, outval)
    move_ahead(cpu, 4)
  end

  defp exec({:eq, [a, b, c]}, cpu) do
    a = read_value(cpu, a)
    b = read_value(cpu, b)

    outval =
      if a == b do
        1
      else
        0
      end

    cpu = write(cpu, c, outval)
    move_ahead(cpu, 4)
  end

  defp exec({:offset, modifier}, cpu) do
    modifier = read_value(cpu, modifier)

    cpu
    |> Map.update!(:relative_base, &(&1 + modifier))
    |> move_ahead(2)
  end

  defp exec(:halt, cpu) do
    {:halted, %{cpu | halted: true}}
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

  def dump_to_iolist(cpu) do
    [
      """

      == CPU =====
      """
      | dump_memory_to_iolist(%{cpu | ip: 0}, cpu.ip)
    ]
  end

  def dump_memory_to_iolist(cpu, original_ip) do
    highlight? = cpu.ip == original_ip

    if Map.has_key?(cpu.memory, cpu.ip) do
      op_val = deref(cpu)

      {chunk, cpu} =
        case read_instr_safe(cpu) do
          {:add, [a, b, c]} ->
            chunk = "#{dump_op(op_val, "ADD")} #{dump_param(a)} #{dump_param(b)} #{dump_param(c)}"
            {chunk, move_ahead(cpu, 4)}

          {:mul, [a, b, c]} ->
            chunk = "#{dump_op(op_val, "MUL")} #{dump_param(a)} #{dump_param(b)} #{dump_param(c)}"
            {chunk, move_ahead(cpu, 4)}

          :halt ->
            chunk = "#{dump_op(op_val, "HALT")}"
            {chunk, move_ahead(cpu, 1)}

          {:iowrite, param} ->
            chunk = "#{dump_op(op_val, "WRITE")} #{dump_param(param)}"
            {chunk, move_ahead(cpu, 2)}

          {:ioread, param} ->
            chunk = "#{dump_op(op_val, "READ")} #{dump_param(param)}"
            {chunk, move_ahead(cpu, 2)}

          {:jumpt, [a, b]} ->
            chunk = "#{dump_op(op_val, "JUMPT")} #{dump_param(a)} #{dump_param(b)}"
            {chunk, move_ahead(cpu, 3)}

          {:jumpf, [a, b]} ->
            chunk = "#{dump_op(op_val, "JUMPF")} #{dump_param(a)} #{dump_param(b)}"
            {chunk, move_ahead(cpu, 3)}

          {:lt, [a, b, c]} ->
            chunk = "#{dump_op(op_val, "LT?")} #{dump_param(a)} #{dump_param(b)} #{dump_param(c)}"
            {chunk, move_ahead(cpu, 4)}

          {:eq, [a, b, c]} ->
            chunk = "#{dump_op(op_val, "EQ?")} #{dump_param(a)} #{dump_param(b)} #{dump_param(c)}"
            {chunk, move_ahead(cpu, 4)}

          {:offset, n} ->
            chunk = "#{dump_op(op_val, "OFFSET")} #{dump_param(n)}"
            {chunk, move_ahead(cpu, 2)}

          {:data, n} when is_integer(n) ->
            chunk = "#{dump_op(n, "DATA")} #{dump_param(n)}"
            {chunk, move_ahead(cpu, 1)}

          other ->
            IO.puts([IO.ANSI.red(), "unknown instruction: #{inspect(other)}", IO.ANSI.reset()])
            System.halt(1)
            Process.sleep(:infinity)
        end

      chunk =
        if highlight? do
          ["=> [", chunk, "]\n"]
        else
          ["    ", chunk, "\n"]
        end

      [chunk | dump_memory_to_iolist(cpu, original_ip)]
    else
      []
    end
  end

  defp read_instr_safe(cpu) do
    read_instr(cpu)
  rescue
    _ -> {:data, deref(cpu, cpu.ip)}
  end

  defp dump_param(n) when is_integer(n) do
    n
    |> Integer.to_string()
    |> String.pad_leading(9)
  end

  defp dump_param({val, mode}) do
    mode_str =
      case mode do
        @mode_position ->
          "*"

        @mode_immediate ->
          "="

        @mode_relative ->
          if val > 0 do
            "+"
          else
            ""
          end
      end

    str = mode_str <> Integer.to_string(val)
    String.pad_leading(str, 9)
  end

  defp dump_op(value, formatted) do
    str = "(#{value |> Integer.to_string()})" |> String.pad_leading(9 - String.length(formatted))
    "#{formatted}#{str}"
  end

  defimpl Inspect do
    def inspect(cpu, _) do
      AdventOfCode.IntCPU.dump_to_iolist(cpu)
      # "#CPU<halted?=#{cpu.halted}>"
      #   %{memory: memory, ip: ip} = cpu
      #   all_intrs = instruction_chunks(cpu)
      #   keys = Map.keys(memory)
      #   {min_key, max_key} = Enum.min_max(keys)

      #   int_width = 8
      #   # max_val = Enum.max(Map.values(memory))
      #   # cond do
      #   #   max_val < 1000 -> 3
      #   #   max_val < 10000 -> 4
      #   #   max_val < 100_000 -> 5
      #   #   max_val < 1_000_000 -> 6
      #   # end + 2

      #   "\n\n" <>
      #     (min_key..max_key
      #      |> Stream.chunk_every(8)
      #      |> Enum.map(fn chunk ->
      #        [Enum.map_intersperse(chunk, " ", &format_int(Map.fetch!(memory, &1), &1, ip, int_width)), "\n"]
      #      end)
      #      |> IO.iodata_to_binary())
      # end

      # defp format_int(int, index, ip, width) do
      #   str = Integer.to_string(int)

      #   if ip == index do
      #     [IO.ANSI.inverse(), String.pad_leading("[#{str}]", width), IO.ANSI.inverse_off()]
      #   else
      #     String.pad_leading(str, width)
      #   end
    end

    # defp instruction_chunks(cpu) do
    #   case IntCPU.read_instr(cpu) do
    #     :x -> :ok
    #   end
    # end
  end
end
