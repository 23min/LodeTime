defmodule LodeTime.MixProject do
  use Mix.Project

  def project do
    [
      app: :lodetime,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {LodeTime.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:yaml_elixir, "~> 2.9"},
      {:jason, "~> 1.4"},
      {:file_system, "~> 1.0"},
      {:thousand_island, "~> 1.3"},
      {:phoenix_pubsub, "~> 2.1"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.1", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "compile"],
      check: ["format --check-formatted", "credo --strict"]
    ]
  end
end
