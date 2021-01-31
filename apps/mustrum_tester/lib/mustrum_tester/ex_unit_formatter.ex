defmodule MustrumTester.ExUnitFormatter do
  @moduledoc ~s"""
  Custom ExUnit Formatter used for gathering tests statistics.

  When the tests finish, the formatter prints the number of tests and
  how many of them succeeded/failed and writes a file with this data so it
  can be used by other modules.

  The formatter supports some special tags. See `Supported Tags`.

  ## ExUnit Tags

    Every test in ExUnit has a map of tags associated to it. These tags can be
    accessed as the second parameter to the test macro. To add a tag to a test,
    write `@tag <tag_name>: <tag_value>` above the test. The result of setup/setup_all
    is also added to the tags.

  ## Supported tagss

    points - The number of points that are awarded if the tests passes. If not
    provided it defaults to 1. More points can be awarded by tests that are checking
    more important and core cases.
    Example: To award more than 1 point to a test, add this above the test: `@tag points: 2`
  """

  use GenServer

  def file_name(), do: __ENV__.file

  def init(_opts) do
    {:ok,
     %{
       received_points: 0,
       total_points: 0,
       success: [],
       failed: [],
       skipped: [],
       excluded: [],
       invalid: []
     }}
  end

  def handle_cast({:suite_finished, _run_us, _load_us}, state) do
    generate_summary(state)
    {:noreply, state}
  end

  def handle_cast({:test_finished, %ExUnit.Test{} = test}, state) do
    test_points = test.tags[:points] || 1

    state =
      case test do
        %{state: nil} ->
          %{
            state
            | success: [test | state.success],
              received_points: state.received_points + test_points,
              total_points: state.total_points + test_points
          }

        %{state: {type, _}} when type in [:failed, :skipped, :exluded, :invalid] ->
          %{
            state
            | type => [test | state[type]],
              total_points: state.total_points + test_points
          }
      end

    {:noreply, state}
  end

  def handle_cast(_msg, state), do: {:noreply, state}

  defp generate_summary(state) do
    counts =
      state
      |> Map.take([:success, :failed, :skipped, :excluded, :invalid])
      |> Map.new(fn {k, v} -> {k, length(v)} end)

    tests_count = Map.values(counts) |> Enum.sum()

    tests_result_file = Path.join([File.cwd!(), "tests_result.txt"])
    state = Map.merge(state, counts)

    counts_list = [
      state.total_points,
      state.received_points,
      tests_count,
      counts.success,
      counts.failed,
      counts.skipped,
      counts.excluded,
      counts.invalid
    ]

    counts_list_str = Enum.join(counts_list, "/")

    File.write!(tests_result_file, counts_list_str)

    IO.puts("""
    Total Test Points: #{state.total_points}
    Points Received: #{state.received_points} (#{
      percent_of(state.received_points, state.total_points)
    }%)

    Total Tests Count: #{tests_count}
    Successfull Tests: #{counts.success} (#{percent_of(counts.success, tests_count)}%)
    Failed Tests: #{counts.failed} (#{percent_of(counts.failed, tests_count)}%)
    Skipped Tests: #{counts.skipped} (#{percent_of(counts.skipped, tests_count)}%)
    Excluded Tests: #{counts.excluded} (#{percent_of(counts.excluded, tests_count)}%)
    Invalid Tests: #{counts.invalid} (#{percent_of(counts.invalid, tests_count)}%)

    #{counts_list_str}
    """)
  end

  defp percent_of(part, total) when is_number(total) and total > 1.0e-7 do
    Float.round(part / total * 100, 2)
  end

  defp percent_of(_, _), do: nil
end
