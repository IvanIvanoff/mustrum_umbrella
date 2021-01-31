defmodule MustrumTester.GitUtils do
  def clone(repo_url, opts) do
    MustrumTester.ExUnitFormatter
    path = Keyword.fetch!(opts, :path)

    case System.cmd("git", ["clone", authorized_url(repo_url), path], stderr_to_stdout: true) do
      {_, 0} -> :ok
      {log, error_code} -> {:error, error_code, log}
    end
  end

  def url_to_name(github_repo_url) do
    github_repo_url
    |> String.trim_trailing(".git")
    |> String.split("/")
    |> List.last()
  end

  defp authorized_url(url) do
    String.replace_prefix(url, "https://", "https://#{user()}:#{password()}@")
  end

  defp user(), do: System.get_env("GITHUB_USERNAME")
  defp password(), do: System.get_env("GITHUB_PASSWORD")
end
