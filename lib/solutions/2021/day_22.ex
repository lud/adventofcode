defmodule Aoe.Y21.Day22 do
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
    Enum.map(input, &parse_line/1)
  end

  @re_line ~r/^(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/
  defp parse_line(line) do
    [onoff, xmin, xmax, ymin, ymax, zmin, zmax] =
      Regex.run(@re_line, line, capture: :all_but_first)

    flag =
      case onoff do
        "on" -> :on
        "off" -> :off
      end

    {flag, String.to_integer(xmin), String.to_integer(xmax), String.to_integer(ymin),
     String.to_integer(ymax), String.to_integer(zmin), String.to_integer(zmax)}
  end

  def part_one(lines) do
    lines =
      lines
      |> Enum.map(&shrink_zone/1)
      |> Enum.filter(&is_tuple/1)

    len = length(lines)

    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, index}, world ->
      IO.puts("#{index}/#{len} #{inspect(line)}")
      apply_line(world, line)
    end)
    |> map_size
  end

  defp shrink_zone({flag, xmin, xmax, ymin, ymax, zmin, zmax} = line) do
    if xmin > 50 || xmin < -50 ||
         ymin > 50 || ymin < -50 ||
         zmin > 50 || zmin < -50 ||
         xmax > 50 || xmax < -50 ||
         ymax > 50 || ymax < -50 ||
         zmax > 50 || zmax < -50 do
      :discard
    else
      {flag, xmin, xmax, ymin, ymax, zmin, zmax}
    end

    # nxmin = clamp(xmin)
    # nxmax = clamp(xmax)
    # nymin = clamp(ymin)
    # nymax = clamp(ymax)
    # nzmin = clamp(zmin)
    # nzmax = clamp(zmax)
  end

  defp clamp(v) do
    clamp(v, -50, 50)
  end

  defp clamp(v, vmin, vmax) do
    v |> max(vmin) |> min(vmax)
  end

  defp apply_line(world, {:off, xmin, xmax, ymin, ymax, zmin, zmax}) do
    for x <- xmin..xmax, y <- ymin..ymax, z <- zmin..zmax, reduce: world do
      world -> Map.delete(world, {x, y, z})
    end
  end

  defp apply_line(world, {:on, xmin, xmax, ymin, ymax, zmin, zmax}) do
    for x <- xmin..xmax, y <- ymin..ymax, z <- zmin..zmax, reduce: world do
      world -> Map.put(world, {x, y, z}, true)
    end
  end

  def part_two(problem) do
    problem
  end
end
