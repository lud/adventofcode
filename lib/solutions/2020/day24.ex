defmodule Aoe.Y20.Day24 do
  alias Aoe.Input, warn: false

  @type input_path :: binary
  @type file :: input_path | %Aoe.Input.FakeFile{}
  @type part :: :part_one | :part_two
  @type input :: binary | File.Stream.t()
  @type problem :: any

  @spec read_file!(Aoe.file(), Aoe.part()) :: Aoe.input()
  def read_file!(file, _part) do
    Input.stream_file_lines(file, trim: true)
  end

  @spec parse_input!(Aoe.input(), Aoe.part()) :: Aoe.problem()
  def parse_input!(input, _part) do
    input
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
  end

  defp parse_line("se" <> rest), do: [:se | parse_line(rest)]
  defp parse_line("sw" <> rest), do: [:sw | parse_line(rest)]
  defp parse_line("ne" <> rest), do: [:ne | parse_line(rest)]
  defp parse_line("nw" <> rest), do: [:nw | parse_line(rest)]
  defp parse_line("e" <> rest), do: [:e | parse_line(rest)]
  defp parse_line("w" <> rest), do: [:w | parse_line(rest)]
  defp parse_line(""), do: []

  def part_one(problem) do
    problem
    |> Enum.map(fn line -> Enum.reduce(line, {0, 0}, &add_qr/2) end)
    |> Enum.reduce(%{}, &flip_tile/2)
    |> count_blacks
  end

  defp count_blacks(qrmap) do
    qrmap
    |> Enum.filter(&black?/1)
    |> length
  end

  def part_two(problem) do
    initial_map =
      problem
      |> Enum.map(fn line -> Enum.reduce(line, {0, 0}, &add_qr/2) end)
      |> Enum.reduce(%{}, &flip_tile/2)

    initial_map
    |> run_days(1, 100)
    |> count_blacks
  end

  defp run_days(qrmap, day, max) when day > max do
    qrmap
  end

  defp run_days(qrmap, day, max) do
    # Identify all the black tiles
    allblacks = Enum.filter(qrmap, &black?/1)

    # Take all black cells and add +1 score to all the neighbours coords
    neigh_counts = Enum.reduce(allblacks, %{}, &black_neighboured_count(&1, &2, qrmap))

    # Add the unlisted blacks with a score of zero
    neigh_counts =
      Enum.reduce(allblacks, neigh_counts, fn {coords, :black}, nc ->
        Map.put_new(nc, coords, 0)
      end)

    qrmap =
      neigh_counts
      |> Enum.reduce(qrmap, fn {neigh, bcount}, qrmap ->
        case Map.get(qrmap, neigh, :white) do
          :white when bcount == 2 -> Map.put(qrmap, neigh, :black)
          :black when bcount == 0 when bcount > 2 -> Map.put(qrmap, neigh, :white)
          _ -> qrmap
        end
      end)

    qrmap
    |> run_days(day + 1, max)
  end

  defp black_neighboured_count({coords, :black}, countmap, qrmap) do
    qrmap
    |> neighbours(coords)
    |> Enum.reduce(countmap, fn {neigh, _}, countmap ->
      Map.update(countmap, neigh, 1, &(&1 + 1))
    end)
  end

  defp black?({_, :black}), do: true
  defp black?({_, :white}), do: false
  # defp white?({_, :white}), do: true
  # defp white?({_, :black}), do: false

  defp flip_tile({q, r}, qrmap) do
    Map.update(qrmap, {q, r}, :black, &switch/1)
  end

  defp switch(:black), do: :white
  defp switch(:white), do: :black

  defp neighbours_coords(coords) do
    [
      add_qr(coords, to_qr_move(:e)),
      add_qr(coords, to_qr_move(:w)),
      add_qr(coords, to_qr_move(:se)),
      add_qr(coords, to_qr_move(:nw)),
      add_qr(coords, to_qr_move(:ne)),
      add_qr(coords, to_qr_move(:sw))
    ]
  end

  defp add_qr({q, r}, {add_q, add_r}) do
    {q + add_q, r + add_r}
  end

  defp add_qr(coords, added) when is_atom(coords) do
    add_qr(to_qr_move(coords), added)
  end

  defp add_qr(coords, added) when is_atom(added) do
    add_qr(coords, to_qr_move(added))
  end

  defp neighbours(qrmap, coords) do
    coords
    |> neighbours_coords()
    |> Enum.map(fn neigh -> {neigh, Map.get(qrmap, neigh, :white)} end)
  end

  defp to_qr_move(:e), do: {+1, 0}
  defp to_qr_move(:w), do: {-1, 0}
  defp to_qr_move(:se), do: {0, +1}
  defp to_qr_move(:nw), do: {0, -1}
  defp to_qr_move(:ne), do: {+1, -1}
  defp to_qr_move(:sw), do: {-1, +1}
end
