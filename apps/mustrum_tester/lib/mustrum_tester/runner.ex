defmodule MustrumTester.Runner do
  alias MustrumTester.GitUtils

  @type repo_url :: String.t()
  @type option :: {:code_repo, repo_url} | {:test_repo, repo_url}

  @spec test([option]) :: any()
  def test(opts) do
    code_repo = Keyword.fetch!(opts, :code_repo)
    tests_repo = Keyword.fetch!(opts, :tests_repo)

    Temp.track!()
    {:ok, temp_dir} = Temp.mkdir(%{prefix: "mustrum-tester-tmp"})

    code_path = Path.join(temp_dir, "code")
    tests_path = Path.join(temp_dir, "tests")

    :ok = GitUtils.clone(code_repo, path: code_path)
    :ok = GitUtils.clone(tests_repo, path: tests_path)

    run_tests(code_path, tests_path)
  end

  defp run_tests(code_path, tests_path) do
    :ok =
      MustrumTester.CodeRepo.Elixir.prepare_code_repo(
        code_path: code_path,
        tests_path: tests_path
      )

    MustrumTester.CodeRepo.Elixir.run_tests(code_path)
  end
end
