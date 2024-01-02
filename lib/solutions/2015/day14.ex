defmodule AdventOfCode.Y15.Day14 do
  alias AoC.Input

  def read_file(file, _part) do
    Input.stream!(file, trim: true)
  end

  def parse_input(input, _part) do
    input |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    [
      name,
      "can",
      "fly",
      speed,
      "km/s",
      "for",
      fly_time,
      "seconds,",
      "but",
      "then",
      "must",
      "rest",
      "for",
      rest_time,
      "seconds."
    ] =
      String.split(line, " ")

    %{
      name: name,
      speed: String.to_integer(speed),
      fly_time: String.to_integer(fly_time),
      rest_time: String.to_integer(rest_time)
    }
  end

  def part_one({deers, seconds}) do
    Enum.reduce(deers, 0, fn deer, best ->
      dist = run_deer(deer, seconds)
      max(dist, best)
    end)
  end

  def part_one(deers) do
    part_one({deers, 2503})
  end

  defp run_deer(deer, seconds) do
    run_deer(deer, :fly, 0, seconds)
  end

  defp run_deer(_deer, _, dist, 0) do
    dist
  end

  defp run_deer(%{fly_time: fly_time} = deer, :fly, dist, seconds) when fly_time > seconds do
    %{speed: speed} = deer
    dist = dist + speed * seconds
    dist
  end

  defp run_deer(deer, :fly, dist, seconds) do
    %{speed: speed, fly_time: fly_time} = deer
    run_deer(deer, :rest, dist + speed * fly_time, seconds - fly_time)
  end

  defp run_deer(%{rest_time: rest_time} = deer, :rest, dist, seconds) when rest_time > seconds do
    dist
  end

  defp run_deer(deer, :rest, dist, seconds) do
    %{rest_time: rest_time, fly_time: fly_time} = deer
    run_deer(deer, :fly, dist, seconds - rest_time)
  end

  def part_two({deers, seconds}) do
    deers = Enum.map(deers, fn deer -> Map.merge(deer, %{status: :fly, seconds: deer.fly_time, distance: 0}) end)
    score = Map.new(deers, fn deer -> {deer.name, 0} end)
    score = reduce(deers, 1, score, seconds)
    score |> Enum.max_by(fn {_, v} -> v end) |> elem(1)
  end

  def part_two(deers) do
    part_two({deers, 2503})
  end

  defp reduce(deers, seconds, score, max_seconds) when seconds > max_seconds do
    score
  end

  defp reduce(deers, second, score, max_seconds) do
    deers = Enum.map(deers, &run_second/1)
    best_distance = Enum.max_by(deers, & &1.distance).distance
    winners = deers |> Enum.filter(fn deer -> deer.distance == best_distance end) |> Enum.map(& &1.name)
    score = Enum.reduce(winners, score, fn name, score -> Map.update!(score, name, &(&1 + 1)) end)
    second |> IO.inspect(label: ~S/second/)
    deers |> dbg()
    score |> dbg()
    reduce(deers, second + 1, score, max_seconds)
  end

  defp run_second(%{status: :rest, distance: d, seconds: 1} = deer) do
    %{deer | status: :fly, seconds: deer.fly_time}
  end

  defp run_second(%{status: :rest, distance: d, seconds: secs} = deer) when secs > 1 do
    %{deer | seconds: secs - 1}
  end

  defp run_second(%{status: :fly, distance: d, seconds: 1} = deer) do
    %{deer | distance: d + deer.speed, status: :rest, seconds: deer.rest_time}
  end

  defp run_second(%{status: :fly, distance: d, seconds: secs} = deer) when secs > 1 do
    %{deer | distance: d + deer.speed, seconds: secs - 1}
  end
end
