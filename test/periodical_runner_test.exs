defmodule PeriodicalRunnerTest do
  use CryptoRates.Case

  describe "emits every 5 ms" do
    setup do
      pid = self()
      PeriodicalRunner.start_link(fn ->
        send(pid, :message)
      end, 20)
      :ok
    end

    test "should receive 5 messages in 100±5 ms" do
      Process.sleep(105)
      assert 5 = get_messages_length()
    end
  end

  defp get_messages_length() do
    {:messages, messages} = :erlang.process_info(self(), :messages)
    length(messages)
  end
end
