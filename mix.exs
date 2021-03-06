defmodule Brintex.MixProject do
  use Mix.Project

  def project do
    [
      app: :brintex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Brintex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:horde, "~> 0.8.3"},
      {:libcluster, "~> 3.2"},
      {:broadway, "~> 0.6"},
      {:broadway_rabbitmq, "~> 0.6"}
    ]
  end
end
