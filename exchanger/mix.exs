defmodule Exchanger.MixProject do
  use Mix.Project

  def project do
    [
      app: :exchanger,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [
        ignore_modules: [
          Exchanger.Api.Http,
          Exchanger.Conversions.Conversion
        ]
      ],

      # Docs
      name: "Exchanger API",
      source_url: "https://github.com/toms099/exchanger_api",
      homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [
        # The main page in the docs
        main: "readme",
        # logo: "",
        extras: ["README.md", "API.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Exchanger.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:finch, "~> 0.10"},
      {:castore, "~> 0.1.0"},
      {:ecto3_mnesia, "~> 0.2.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:mox, "~> 0.5.2", only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
