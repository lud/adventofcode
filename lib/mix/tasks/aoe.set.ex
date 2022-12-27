defmodule Mix.Tasks.Aoe.Set do
  alias Aoe.CliTool

  use Mix.Task

  def run(argv) do
    Application.ensure_all_started(:aoe)

    command = [
      module: __MODULE__,
      doc: "Sets the default year when not provided on other commands",
      options: [
        year: [type: :integer, short: :y, doc: "Year to force"]
      ]
    ]

    %{options: options} = CliTool.parse_or_halt!(argv, command)

    CliTool.write_defaults(options)
  end
end
