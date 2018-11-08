defmodule Shurl.Expirator do
  use GenServer
  alias Shurl.Storage

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(%{}) do
    run_work()

    {:ok, %{}}
  end

  def handle_info(:work, state) do
    Storage.Link.update_expired_links
    schedule_work()

    {:noreply, state}
  end

  defp run_work() do
    Process.send(self(), :work, [])
  end

  defp schedule_work() do
    Process.send_after(self(), :work, period())
  end

  defp period() do
    Application.get_env(:shurl, :period)
  end
end
