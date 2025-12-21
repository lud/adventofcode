defmodule AdventOfCode.IntCPU.IOBuf do
  defstruct [:input, :output]

  def new(input) when is_list(input) do
    %__MODULE__{input: input, output: []}
  end

  def read(%{input: [h | t]} = buf), do: {h, %{buf | input: t}}

  # Output is reversed
  def write(%{output: t} = buf, v), do: %{buf | output: [v | t]}

  def as_fun(buf) do
    fn
      :init -> buf
      {:input, buf} -> read(buf)
      {:output, value, buf} -> write(buf, value)
    end
  end
end
