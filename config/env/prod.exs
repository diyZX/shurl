use Mix.Config

config :logger,
  level: :debug

config :ecto,
  json_library: Jason

config :maru, Shurl.API,
  http: [port: 8888, bind_addr: "0.0.0.0"]

config :shurl,
  ecto_repos: [Shurl.Repo],
  expiration_time: (30 * 24) |> :timer.hours,
  period: 1 |> :timer.hours

config :shurl, Shurl.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "shurl",
  hostname: "db",
  port: 5432,
  username: "postgres",
  password: "postgres"
