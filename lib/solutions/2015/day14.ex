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

    {name, String.to_integer(speed), String.to_integer(fly_time), String.to_integer(rest_time)}
  end

  def part_one({deers, seconds}) do
    Enum.reduce(deers, 0, fn deer, best ->
      {_, dist} = run_deer(deer, seconds)
      max(dist, best)
    end)
  end

  def part_one(deers) do
    part_one({deers, 2503})
  end

  defp run_deer(deer, seconds) do
    run_deer(deer, :fly, 0, seconds)
  end

  defp run_deer({name, _, _, _}, _, dist, 0) do
    {name, dist}
  end

  defp run_deer({name, speed, fly_time, _}, :fly, dist, seconds) when fly_time > seconds do
    dist = dist + speed * seconds
    {name, dist}
  end

  defp run_deer({name, speed, fly_time, rest_time}, :fly, dist, seconds) do
    run_deer({name, speed, fly_time, rest_time}, :rest, dist + speed * fly_time, seconds - fly_time)
  end

  defp run_deer({name, _, _, rest_time}, :rest, dist, seconds) when rest_time > seconds do
    {name, dist}
  end

  defp run_deer({name, speed, fly_time, rest_time}, :rest, dist, seconds) do
    run_deer({name, speed, fly_time, rest_time}, :fly, dist, seconds - rest_time)
  end

  # def part_two(problem) do
  #   problem
  # end
end
