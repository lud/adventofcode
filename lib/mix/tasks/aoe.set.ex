defmodule Mix.Tasks.Aoe.Set do
  alias Aoe.CliTool
  use Mix.Task

  @shortdoc "Sets or reset default year and day options for other commands"

  def run(argv) do
    Application.ensure_all_started(:aoe)

    command = [
      module: __MODULE__,
      doc: "Sets the default year / day when not provided on other commands",
      options: [
        year: [type: :integer, short: :y, doc: "Year to force"],
        day: [type: :integer, short: :d, doc: "Day to force"]
      ]
    ]

    %{options: options} = CliTool.parse_or_halt!(argv, command)

    CliTool.write_defaults(options)
  end
end
