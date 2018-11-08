use Mix.Config

config :logger,
  level: :info

config :ecto,
  json_library: Jason

config :shurl,
  ecto_repos: [Shurl.Repo],
  cache: :shurl_cache,
  expiration_time: (30 * 24) |> :timer.hours,
  period: 1 |> :timer.hours

config :shurl, Shurl.Repo,
  adapter: Ecto.Adapters.Postgres

import_config "env/#{Mix.env}.exs"

if File.exists?(Path.join([Path.dirname(__ENV__.file), "local/#{Mix.env}.exs"])) do
  import_config "local/#{Mix.env}.exs"
end
