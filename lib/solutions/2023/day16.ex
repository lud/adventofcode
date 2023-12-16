defmodule AdventOfCode.Y23.Day16 do
  alias AoC.Input, warn: false
  alias AoC.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Grid.parse_stream(&parse_char/1)
  end

  defp parse_char(x), do: {:ok, x}

  def part_one(grid) do
    energize({{0, 0}, :e}, grid)
  end

  def part_two(grid) do
    xa = 0
    ya = 0
    xo = Grid.max_x(grid)
    yo = Grid.max_y(grid)

    (Enum.flat_map(xa..xo, fn x -> [{{x, ya}, :s}, {{x, yo}, :n}] end) ++
       Enum.flat_map(ya..yo, fn y -> [{{xa, y}, :e}, {{xo, y}, :w}] end))
    |> Enum.reduce(0, fn pos, best ->

      case energize(pos, grid) do
        n when n > best -> n
        _ -> best
      end
    end)
  end

  defp energize({xy, dir}, grid) do
    rays = [{xy, dir}]
    done = %{}

    sim = simulate(rays, done, grid)

    sim |> Enum.uniq_by(fn {{xy, _}, true} -> xy end) |> length()
  end

  defp simulate([_ | _] = rays, done, grid) do
    {new_rays, done} =
      Enum.flat_map_reduce(rays, done, fn
        ray, done when is_map_key(done, ray) ->
          {[], done}

        {xy, _} = ray, done ->
          case Map.fetch(grid, xy) do
            {:ok, cell} ->
              new_rays = simcell(ray, cell)
              done = Map.put(done, ray, true)
              {new_rays, done}

            :error ->
              {[], done}
          end
      end)

    # print_done(done, grid)
    simulate(new_rays, done, grid)
  end

  defp simulate([], done, grid) do
    done
  end

  defp simcell(ray, "."), do: [continue(ray)]

  defp simcell({xy, dir}, "|") when dir in [:e, :w] do
    [{Grid.translate(xy, :n), :n}, {Grid.translate(xy, :s), :s}]
  end

  defp simcell({xy, dir} = ray, "|") when dir in [:n, :s] do
    [continue(ray)]
  end

  defp simcell({xy, dir}, "-") when dir in [:n, :s] do
    [{Grid.translate(xy, :e), :e}, {Grid.translate(xy, :w), :w}]
  end

  defp simcell({xy, dir} = ray, "-") when dir in [:e, :w] do
    [continue(ray)]
  end

  defp simcell({xy, :e}, "/"), do: [{Grid.translate(xy, :n), :n}]
  defp simcell({xy, :e}, "\\"), do: [{Grid.translate(xy, :s), :s}]
  defp simcell({xy, :n}, "/"), do: [{Grid.translate(xy, :e), :e}]
  defp simcell({xy, :n}, "\\"), do: [{Grid.translate(xy, :w), :w}]
  defp simcell({xy, :s}, "/"), do: [{Grid.translate(xy, :w), :w}]
  defp simcell({xy, :s}, "\\"), do: [{Grid.translate(xy, :e), :e}]
  defp simcell({xy, :w}, "/"), do: [{Grid.translate(xy, :s), :s}]
  defp simcell({xy, :w}, "\\"), do: [{Grid.translate(xy, :n), :n}]

  #  --

  defp continue({xy, dir}), do: {Grid.translate(xy, dir), dir}
end
