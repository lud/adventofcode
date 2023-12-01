defmodule AdventOfCode.Y21.Day24.Program do
  def run(0, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 12
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 4
    y = y * x
    z = z + y
    z
  end

  def run(1, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 11
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 10
    y = y * x
    z = z + y
    z
  end

  def run(2, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 14
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 12
    y = y * x
    z = z + y
    z
  end

  def run(3, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -6
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 14
    y = y * x
    z = z + y
    z
  end

  def run(4, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 15
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 6
    y = y * x
    z = z + y
    z
  end

  def run(5, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 12
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 16
    y = y * x
    z = z + y
    z
  end

  def run(6, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -9
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 1
    y = y * x
    z = z + y
    z
  end

  def run(7, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 14
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 7
    y = y * x
    z = z + y
    z
  end

  def run(8, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 1)
    x = x + 14
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 8
    y = y * x
    z = z + y
    z
  end

  def run(9, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -5
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 11
    y = y * x
    z = z + y
    z
  end

  def run(10, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -9
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 8
    y = y * x
    z = z + y
    z
  end

  def run(11, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -5
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 3
    y = y * x
    z = z + y
    z
  end

  def run(12, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -2
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 1
    y = y * x
    z = z + y
    z
  end

  def run(13, w, z) do
    x = 0
    x = x + z
    x = rem(x, 26)
    z = div(z, 26)
    x = x + -7
    x = eql(x, w)
    x = eql(x, 0)
    y = 0
    y = y + 25
    y = y * x
    y = y + 1
    z = z * y
    y = 0
    y = y + w
    y = y + 8
    y = y * x
    z = z + y
    z
  end

  defp eql(same, same), do: 1
  defp eql(_, _), do: 0
end
