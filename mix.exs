defmodule PhoenixPubsubLaspPg.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_pubsub_lasp_pg,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      description: """
      Lasp PG PubSub adapter for the Phoenix framework
      """
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_pubsub, "~> 1.0"},
      {:lasp_pg, "~> 0.1.0"},
      {:ex_doc, "~> 0.17.1", only: :docs}
    ]
  end

  defp package do
    [maintainers: ["Jacob Lerche"], licenses: ["MIT"]]
  end
end
