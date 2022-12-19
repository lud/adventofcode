defmodule Aoe.Y22.Day19 do
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
    input |> Enum.map(&parse_blueprint/1)
  end

  @re_line ~r/Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./
  def parse_blueprint(line) do
    [id, ore_ore, clay_ore, obs_ore, obs_clay, geo_ore, geo_obs] =
      Regex.run(@re_line, line, capture: :all_but_first) |> Enum.map(&String.to_integer/1)

    {id,
     %{
       rbot: %{ore: ore_ore},
       cbot: %{ore: clay_ore},
       obot: %{ore: obs_ore, clay: obs_clay},
       gbot: %{ore: geo_ore, obsidian: geo_obs}
     }}
  end

  def part_one(id_bps) do
    id_bps
    |> Enum.map(fn {id, bp} ->
      best = best_sim(bp, 24)
      id * best.geodes
    end)
    |> Enum.sum()
  end

  def part_two(id_bps) do
    id_bps
    |> Enum.take(3)
    |> Enum.map(fn {_id, bp} ->
      best = best_sim(bp, 32)
      best.geodes
    end)
    |> Enum.product()
  end

  def best_sim(bp, minutes) do
    init = %{ores: 0, clays: 0, obsidians: 0, geodes: 0, rbots: 1, cbots: 0, obots: 0, gbots: 0}
    _best = best_sim([init], bp, minutes)
  end

  defp best_sim(states, bp, minutes) when minutes > 0 do
    Process.put(:minute, 24 - minutes + 1)
    new_states = Enum.flat_map(states, &drop_minute(&1, bp))

    bests =
      new_states
      |> Enum.sort_by(fn %{rbots: r, cbots: c, obots: o, gbots: g} ->
        r |> max(c * 1000) |> max(o * 1_000_000) |> max(g * 1_000_000_000) |> Kernel.*(-1)
      end)
      |> Enum.take(10_000)

    best_sim(bests, bp, minutes - 1)
  end

  defp best_sim(states, _, _) do
    Enum.max_by(states, fn %{geodes: g} -> g end)
  end

  defp drop_minute(state, bp) do
    gather = gather_mats(state)

    state_builds = [state]
    state_builds = maybe_append_build(:rbot, bp, state, state_builds)
    state_builds = maybe_append_build(:cbot, bp, state, state_builds)
    state_builds = maybe_append_build(:obot, bp, state, state_builds)
    state_builds = maybe_append_build(:gbot, bp, state, state_builds)

    Enum.map(state_builds, &add_mats(&1, gather))
  end

  defp gather_mats(state) do
    %{rbots: rb, cbots: cb, obots: ob, gbots: gb} = state

    %{ores: rb, clays: cb, obsidians: ob, geodes: gb}
  end

  defp add_mats(state, adds) do
    %{ores: r, clays: c, obsidians: o, geodes: g} = state
    %{ores: ra, clays: ca, obsidians: oa, geodes: ga} = adds

    %{state | ores: r + ra, clays: c + ca, obsidians: o + oa, geodes: g + ga}
  end

  defp rm_mats(state, %{ore: ra, clay: ca}) do
    %{ores: r, clays: c} = state
    %{state | ores: r - ra, clays: c - ca}
  end

  defp rm_mats(state, %{ore: ra, obsidian: oa}) do
    %{ores: r, obsidians: o} = state
    %{state | ores: r - ra, obsidians: o - oa}
  end

  defp rm_mats(state, %{ore: ra}) do
    %{ores: r} = state
    %{state | ores: r - ra}
  end

  defp add_bot(%{rbots: r} = state, :rbot), do: %{state | rbots: r + 1}
  defp add_bot(%{cbots: r} = state, :cbot), do: %{state | cbots: r + 1}
  defp add_bot(%{obots: r} = state, :obot), do: %{state | obots: r + 1}
  defp add_bot(%{gbots: r} = state, :gbot), do: %{state | gbots: r + 1}

  defp maybe_append_build(what, bp, state, states) do
    bot_bp = Map.fetch!(bp, what)

    if can_build?(what, bot_bp, state) do
      state = rm_mats(state, bot_bp)
      state = add_bot(state, what)
      # what |> IO.inspect(label: "built")
      [state | states]
    else
      states
    end
  end

  defp can_build?(:rbot, %{ore: cost}, %{ores: have}) do
    have >= cost
  end

  defp can_build?(:cbot, %{ore: cost}, %{ores: have}) do
    have >= cost
  end

  defp can_build?(:obot, %{ore: rcost, clay: ccost}, %{ores: rhave, clays: chave}) do
    rhave >= rcost and chave >= ccost
  end

  defp can_build?(:gbot, %{ore: rcost, obsidian: ocost}, %{ores: rhave, obsidians: ohave}) do
    rhave >= rcost and ohave >= ocost
  end
end
