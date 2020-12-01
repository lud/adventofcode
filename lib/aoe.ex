defmodule Aoe do
  alias Aoe.Utils
  alias Aoe.Input

  def run(year, day, part) when part in [:part_one, :part_two] do
    module = Utils.module_name(year, day)
    run(year, day, module, part)
  end

  def run(year, day, module, part) when is_atom(module) and part in [:part_one, :part_two] do
    with {:module, _} <- Code.ensure_loaded(module),
         {:ok, input_path} <- Input.ensure_local(year, day),
         :ok <- ensure_part(module, part) do
      {:ok, do_run_part(module, part, input_path)}
    else
      {:error, :nofile} -> {:error, :not_implemented}
      {:error, _} = err -> err
    end
  end

  defp ensure_part(module, part) do
    if function_exported?(module, part, 1) do
      :ok
    else
      {:error, :not_implemented}
    end
  end

  defp do_run_part(module, part, input_path) do
    input = module.read_file!(input_path, part)
    problem = module.parse_input!(input, part)
    apply(module, part, [problem])
  end
end
