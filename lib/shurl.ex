defmodule Shurl do
  use Application

  def start(_type, _args) do
    children = [
      %{id: ConCache, start: {ConCache, :start_link,
                              [[ttl_check_interval: false, name: Shurl.Cache.name()]]}},
      Shurl.Repo,
      Shurl.Analyst
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children ++ env_children(Mix.env), opts)
  end

  defp env_children(:test), do: []
  defp env_children(_)do
    [
      Shurl.Expirator
    ]
  end
end
