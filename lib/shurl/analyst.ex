defmodule Shurl.Analyst do
  use GenServer
  alias Shurl.{Schema, Cache, Storage}

  ### Public API

  def process(%Plug.Conn{} = conn) do
    :ok = GenServer.cast(__MODULE__, {:process, conn})
  end

  ### Callbacks

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(%{}) do
    {:ok, %{}}
  end

  def handle_cast({:process, %Plug.Conn{req_headers: headers} = conn}, state) do
    headers = Enum.reduce(headers, %{}, fn {k, v}, acc -> Map.put(acc, k, v) end)
    short_code = conn.params["short_code"]
    link_id =
      case Cache.read(short_code) || Storage.Link.get_link(%{short_code: short_code}) do
        {link_id, _}              -> link_id
        %Schema.Link{id: link_id} -> link_id
      end
    %Schema.Click{link_id: link_id, headers: headers |> Jason.encode!}
    |> Schema.Click.changeset
    |> Storage.Click.insert_click

    {:noreply, state}
  end
end
