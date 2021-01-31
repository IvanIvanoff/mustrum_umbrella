defmodule MustrumTester.CodeRepo.Elixir do
  @moduledoc """
  A module that knows how to work with Elixir repositories
  """

  @behaviour MustrumTester.CodeRepo.Behaviour

  # WTF.
  @ex_unit_formatter_source_code File.read!(MustrumTester.ExUnitFormatter.file_name())

  @doc """
  Given a path containing the to-be-tested code repo and path containing tests,
  remove the test directory from the code repo and copy the provided tests
  there. Additionally, add the ExUnit formatter needed in order to obtain the
  results from the tests
  """
  @impl true
  def prepare_code_repo(opts) do
    code_path = Keyword.fetch!(opts, :code_path)
    tests_path = Keyword.fetch!(opts, :tests_path)

    code_test_path = Path.join(code_path, "test")
    tests_test_path = Path.join(tests_path, "test")

    {_, 0} = System.cmd("rm", ["-Rf", code_test_path])
    {_, 0} = System.cmd("cp", ["-R", tests_test_path, code_test_path])

    formatter_path = Path.join([code_path, "lib", "mustrum_ex_unit_code_formatter.ex"])
    bash_script_path = Path.join(code_path, "run_tests.sh")

    File.write!(formatter_path, @ex_unit_formatter_source_code)
    File.write!(bash_script_path, run_tests_bash_script())

    :ok
  end

  @doc ~s"""
  Run the Elixir tests with the Mix tool in the provided path.

  When invoking this function, path must be properly constructed. It should
  contain the code to be tested, as well as the tests and the ExUnit formatter
  """
  @impl true
  def run_tests(path) do
    try do
      script = Path.join(path, "run_tests.sh")
      {captured_stdout, _} = System.cmd("/bin/bash", [script], cd: path, stderr_to_stdout: true)
      # The last line looks like: 20/7/10/2/7/0/0. Alternatively, the tests_result.txt
      # file in the path can be read

      result = captured_stdout |> String.trim() |> String.split("\n") |> List.last()

      case String.split(result, "/") do
        list when is_list(list) and length(list) == 8 ->
          [total_points, points, total_tests, success, failed, skipped, excluded, invalid] =
            list |> Enum.map(&String.to_integer/1)

          %{
            total_points: total_points,
            received_points: points,
            total_tests: total_tests,
            success: success,
            failed: failed,
            skipped: skipped,
            excluded: excluded,
            invalid: invalid
          }

        data ->
          IO.inspect("HENLO")

          raise(
            "The output of the tests does not match the required format. Got: #{inspect(data)}"
          )
      end
    rescue
      error -> {:error, "Cannot run tests. Reason: " <> inspect(error)}
    end
  end

  defp run_tests_bash_script() do
    """
    #!/bin/sh

    mix deps.get
    mix deps.compile
    mix compile
    mix test --formatter MustrumTester.ExUnitFormatter
    """
  end
end
