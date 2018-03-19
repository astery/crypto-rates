defmodule CryptoRatesTest do
  use CryptoRates.Case

  setup do
    CryptoRates.start_periodical_runner
    on_exit fn ->
      CryptoRates.terminate_periodical_runner
    end
    CryptoRates.PubSub.subscribe()
    :ok
  end

  test "should begin to receiving rates" do
    assert_receive({:crypto_rates, _rates}, 1000)
    assert_receive({:crypto_rates, _rates}, 1000)
  end

  test "should recover after occasional fail" do
    assert_receive({:crypto_rates, _rates}, 1000)

    get_runner_pid() |> Process.exit(:kill)

    assert_receive({:crypto_rates, _rates}, 1000)
    assert_receive({:crypto_rates, _rates}, 1000)
  end

  defp get_runner_pid() do
    [pid] =
      Supervisor.which_children(CryptoRates.Supervisor)
      |> Enum.flat_map(fn
        {PeriodicalRunner, pid, _, _} -> [pid]
        _ -> []
      end)
    pid
  end

  # should shutdown after 3 sequential fails
end
