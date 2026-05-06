defmodule TallerElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :taller_elixir,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    if Mix.env() == :test do
      [extra_applications: [:logger]]
    else
      [
        mod: {TallerElixir, []},
        extra_applications: [:logger]
      ]
    end
  end

  defp deps do
    [
      {:jason, "~> 1.4"}
    ]
  end
end
