defmodule Exgen.MixProject do
  use Mix.Project

  def project do
    [
      app: :exgen,
      version: "0.6.0-dev",
      elixir: ">= 1.9.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    []
  end
end
