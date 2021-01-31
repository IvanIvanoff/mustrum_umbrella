defmodule MustrumTester.CodeRepo.Behaviour do
  @type path :: String.t()
  @type option :: {:code_path, path} | {:tests_path, path}
  @type tests_result :: %{
          total_points: non_neg_integer(),
          received_points: non_neg_integer(),
          total_tests: non_neg_integer(),
          success: non_neg_integer(),
          failed: non_neg_integer(),
          skipped: non_neg_integer(),
          excluded: non_neg_integer(),
          invalid: non_neg_integer()
        }

  @callback prepare_code_repo([option]) :: :ok | no_return()

  @callback run_tests(path) :: tests_result | {:error, String.t()}
end
