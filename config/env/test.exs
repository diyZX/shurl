use Mix.Config

config :maru, Shurl.API,
  http: [port: 8889]

config :shurl,
  cache: :shurl_cache_test

config :shurl, Shurl.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  database: "shurl_test",
  port: 5432,
  hostname: "localhost",
  username: "postgres",
  password: "postgres"
