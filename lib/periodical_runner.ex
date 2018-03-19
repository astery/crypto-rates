defmodule PeriodicalRunner do
  use GenServer

  def start_link(job, period) do
    GenServer.start_link(__MODULE__, %{job: job, period: period})
  end

  def init(state) do
    GenServer.cast(self(), :init)
    {:ok, state}
  end

  def handle_cast(:init, %{period: period} = state) do
    {:noreply, state, period}
  end

  def handle_info(:timeout, %{job: job, period: period} = state) do
    Task.start_link(job)
    {:noreply, state, period}
  end
end
