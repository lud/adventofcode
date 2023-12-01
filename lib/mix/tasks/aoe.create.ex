defmodule Mix.Tasks.Aoe.Create do
  alias Aoe.CliTool
  use Mix.Task

  @app_dir File.cwd!()

  @shortdoc "Create the files to solve a problem"
  def run(argv) do
    Application.ensure_all_started(:aoe)

    %{options: options} = CliTool.parse_or_halt!(argv, CliTool.year_day_command(__MODULE__))
    %{year: year, day: day} = CliTool.validate_options!(options)

    download_input = Task.async(Aoe.Input, :ensure_local, [year, day])

    ensure_solution_module(year, day)
    ensure_test(year, day)
    Mix.Task.run("format")
    Mix.Task.run("compile")

    case Task.await(download_input) do
      {:ok, path} ->
        Mix.Shell.IO.info("Input file exists in #{path}")

      {:error, reason} ->
        Mix.Shell.IO.info("Warning: Could not download input: #{inspect(reason)}")
    end

    Mix.Shell.IO.info("Done.")
  end

  defp ensure_solution_module(year, day) do
    module_dir = Path.join([@app_dir, "lib", "solutions", "#{year}"])
    File.mkdir_p!(module_dir)
    module_path = Path.join(module_dir, "day#{day}.ex")

    if File.exists?(module_path) do
      Mix.Shell.IO.info("module exists in #{module_path}")
    else
      module = Aoe.Mod.module_name(year, day)
      code = module_code(module)
      Mix.Shell.IO.info("creating module #{inspect(module)} in #{module_path}")
      File.write!(module_path, code)
    end

    :ok
  end

  defp ensure_test(year, day) do
    test_dir = Path.join([@app_dir, "test", "#{year}"])
    File.mkdir_p!(test_dir)
    test_path = Path.join(test_dir, "day#{day}_test.exs")

    if File.exists?(test_path) do
      Mix.Shell.IO.info("test exists in #{test_path}")
    else
      test_module = Aoe.Mod.test_module_name(year, day)
      module = Aoe.Mod.module_name(year, day)
      code = test_code(test_module, module, test_path, year, day)
      Mix.Shell.IO.info("creating test #{inspect(test_module)} in #{test_path}")
      File.write!(test_path, code)
    end

    :ok
  end

  defp module_code(module) do
    """
    defmodule #{inspect(module)} do
      alias Aoe.Input, warn: false

      def read_file!(file, _part) do
        # Input.read!(file)
        # Input.stream!(file, trim: true)
      end

      def parse_input!(input, _part) do
        input
      end

      def part_one(problem) do
        problem
      end

      def part_two(problem) do
        problem
      end
    end
    """
  end

  defp test_code(test_module, module, _test_path, year, day) do
    ~s[
    defmodule #{inspect(test_module)} do
      alias Aoe.Input, warn: false
      alias #{inspect(module)}, as: Solution, warn: false
      use ExUnit.Case, async: true

      # To run the test, run one of the following commands:
      #
      #     mix test test/#{year}/day#{day}_test.exs
      #     mix aoe.test --year #{year} --day #{day}
      #
      # To run the solution
      #
      #     mix aoe.run --year #{year} --day #{day} --part 1
      #
      # Use sample input file, for instance in priv/input/#{year}/"day-#{day}-sample.inp"
      #
      #     {:ok, path} = Input.resolve(#{year}, #{day}, "sample")
      #

      @sample_1 """
      This is
      A Fake
      Data file
      """

      test "verify #{year}/#{day} part_one - samples" do
        problem =
          @sample_1
          |> Input.as_file()
          |> Solution.read_file!(:part_one)
          |> Solution.parse_input!(:part_one)

        expected = CHANGE_ME
        assert expected == Solution.part_one(problem)
      end

      # test "verify #{year}/#{day} part_two - samples" do
      #   problem =
      #     @sample_1
      #     |> Input.as_file()
      #     |> Solution.read_file!(:part_two)
      #     |> Solution.parse_input!(:part_two)
      #
      #   expected = CHANGE_ME
      #   assert expected == Solution.part_two(problem)
      # end

      # Once your part one was successfully sumbitted, you may uncomment this test
      # to ensure your implementation was not altered when you implement part two.

      # @part_one_solution CHANGE_ME
      #
      # test "verify #{year}/#{day} part one" do
      #   assert {:ok, @part_one_solution} == Aoe.run(#{year}, #{day}, :part_one)
      # end

      # You may also implement a test to validate the part two to ensure that you
      # did not broke your shared modules when implementing another problem.

      # @part_two_solution CHANGE_ME
      #
      # test "verify #{year}/#{day} part two" do
      #   assert {:ok, @part_two_solution} == Aoe.run(#{year}, #{day}, :part_two)
      # end

    end
    ]
  end
end
