defmodule Aoe.Utils do
  def conf_dir!(conf_key) do
    dir = Application.fetch_env!(:aoe, conf_key)
    File.mkdir_p!(dir)
    dir
  end

  def current_day() do
    DateTime.utc_now().day
  end

  def current_year() do
    DateTime.utc_now().year
  end

  def module_name(year, day) do
    Module.concat([Aoe, "Y#{year - 2000}", "Day#{day}"])
  end

  def test_module_name(year, day) do
    Module.concat([Aoe, "Y#{year - 2000}", "Day#{day}Test"])
  end

  defguard is_valid_day(year, day) when year in 2015..2022 and day in 1..25
end
