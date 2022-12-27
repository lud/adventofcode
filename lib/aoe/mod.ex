defmodule Aoe.Mod do
  def module_name(year, day) do
    Module.concat([Aoe, "Y#{year - 2000}", "Day#{day}"])
  end

  def test_module_name(year, day) do
    Module.concat([Aoe, "Y#{year - 2000}", "Day#{day}Test"])
  end
end
