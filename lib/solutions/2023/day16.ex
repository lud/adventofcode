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
    rays = [{{0, 0}, :e}]
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

  defp print_done(done, grid) do
    done
    |> Map.new(fn {{xy, dir}, true} -> {xy, dir} end)
    |> then(&Map.merge(grid, &1))
    |> Grid.print_map(fn
      :e -> ">"
      :s -> "v"
      :w -> "<"
      :n -> "^"
      c when is_binary(c) -> c
      nil -> " "
    end)
  end

  # def part_two(problem) do
  #   problem
  # end
end
