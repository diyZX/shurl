use Mix.Config

config :logger, :console,
  level: :debug,
  format: "$date $time [$level] $metadata$message\n"

config :maru, Shurl.API,
  http: [port: 8888]

config :shurl, Shurl.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "shurl",
  port: 5432,
  hostname: "localhost",
  username: "postgres",
  password: "postgres"


