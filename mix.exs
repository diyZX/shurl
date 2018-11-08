defmodule Shurl.MixProject do
  use Mix.Project

  def project do
    [
      app: :shurl,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test":       ["ecto.reset", "ecto.create --quiet", "ecto.migrate", "run test/test_seeds.exs", "test"]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :con_cache, :maru],
      mod: {Shurl, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:con_cache, "~> 0.13.0"},
      {:cowboy, "~> 1.1.2"},
      {:maru, "~> 0.12.5"},
      {:postgrex, "~> 0.13.3"},
      {:ecto, "~> 2.2"}
    ]
  end
end
