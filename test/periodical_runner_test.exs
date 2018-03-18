defmodule PeriodicalRunner do
  use CryptoRates.Case

  describe "emits every 5 ms" do
    setup do
      pid = self()
      PeriodicalRunner.start(fn ->
        send(pid, :message)
      end, 5)
    end

    test "should receive 5 messages in 25±2 ms" do
      Process.sleep(25)
      messages = :erlang.process_info(self(), :messages)
      assert 5 = length(messages)
    end
  end
end
