defmodule AdventOfCode.IntCPU.IOBuf do
  defstruct [:input, :output]

  def new(input) when is_list(input) do
    %__MODULE__{input: input, output: []}
  end

  def read(%{input: [h | t]} = buf), do: {h, %{buf | input: t}}
  # TODO optimize writing output, not append to end of list
  def write(%{output: t} = buf, v), do: %{buf | output: t ++ [v]}
end
