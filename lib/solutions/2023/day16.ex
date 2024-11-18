defmodule AdventOfCode.Y23.Day16 do
  alias AoC.Input, warn: false
  alias AdventOfCode.Grid

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Grid.parse_stream(fn <<c>> -> {:ok, c} end)
  end

  def part_one(grid) do
    energize({{0, 0}, :e}, grid)
  end

  def part_two(grid) do
    xa = 0
    ya = 0
    xo = Grid.max_x(grid)
    yo = Grid.max_y(grid)

    vertical = Enum.map(xa..xo, fn x -> [{{x, ya}, :s}, {{x, yo}, :n}] end)
    horizontal = Enum.map(ya..yo, fn y -> [{{xa, y}, :e}, {{xo, y}, :w}] end)

    all = :lists.flatten([vertical, horizontal])

    all
    |> Task.async_stream(fn pos -> energize(pos, grid) end, ordered: false)
    |> Enum.reduce(0, fn {:ok, x}, best -> max(x, best) end)
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

    simulate(new_rays, done, grid)
  end

  defp simulate([], done, _grid) do
    done
  end

  defp simcell(ray, ?.), do: [continue(ray)]

  defp simcell({xy, dir}, ?|) when dir in [:e, :w] do
    [{Grid.translate(xy, :n), :n}, {Grid.translate(xy, :s), :s}]
  end

  defp simcell({_, dir} = ray, ?|) when dir in [:n, :s] do
    [continue(ray)]
  end

  defp simcell({xy, dir}, ?-) when dir in [:n, :s] do
    [{Grid.translate(xy, :e), :e}, {Grid.translate(xy, :w), :w}]
  end

  defp simcell({_, dir} = ray, ?-) when dir in [:e, :w] do
    [continue(ray)]
  end

  defp simcell({xy, :e}, ?/), do: [{Grid.translate(xy, :n), :n}]
  defp simcell({xy, :e}, ?\\), do: [{Grid.translate(xy, :s), :s}]
  defp simcell({xy, :n}, ?/), do: [{Grid.translate(xy, :e), :e}]
  defp simcell({xy, :n}, ?\\), do: [{Grid.translate(xy, :w), :w}]
  defp simcell({xy, :s}, ?/), do: [{Grid.translate(xy, :w), :w}]
  defp simcell({xy, :s}, ?\\), do: [{Grid.translate(xy, :e), :e}]
  defp simcell({xy, :w}, ?/), do: [{Grid.translate(xy, :s), :s}]
  defp simcell({xy, :w}, ?\\), do: [{Grid.translate(xy, :n), :n}]

  defp continue({xy, dir}), do: {Grid.translate(xy, dir), dir}
end
