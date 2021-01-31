# MustrumTester

Test the code in one github repo by executing the tests from another repo.

Example usage:

```elixir
iex(1)> MustrumTester.Runner.test(
  code_repo: "https://github.com/IvanIvanoff/code_repo_example",
  tests_repo: "https://github.com/IvanIvanoff/test_repo_example"
)
%{
  excluded: 0,
  failed: 2,
  invalid: 0,
  received_points: 2,
  skipped: 0,
  success: 2,
  total_points: 4,
  total_tests: 4
}
```
