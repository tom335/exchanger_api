defmodule Exchanger.MixProject do
  use Mix.Project

  @test_envs [:test, :integration]

  def project do
    [
      app: :exchanger,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      test_paths: test_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [
        ignore_modules: [
          Exchanger.Api.Http,
          Exchanger.Conversions.Conversion,
          Exchanger.Util.LoadRates
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
      ],
      aliases: aliases()
    ]
  end

  defp elixirc_paths(env) when env in @test_envs, do: ["lib", "test/#{env}"]
  defp elixirc_paths(_), do: ["lib"]
  defp test_paths(:integration), do: ["test/integration"]
  defp test_paths(_), do: ["test/unit"]

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

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "setup.db": &run_setup_db/1,
      "test.all": ["test.unit", "test.integratioan"],
      "test.unit": &run_unit_tests/1,
      "test.integration": &run_integration_tests/1
    ]
  end

  def run_setup_db(_args) do
    Enum.each(["dev", "test", "integration", "prod"], fn env ->
      run_with_env("run", env, ["./priv/repo/mnesia_migration.exs"]) end)
  end

  def run_integration_tests(args), do: run_with_env("test", "integration", args)
  def run_unit_tests(args), do: run_with_env("test", "test", args)

  def run_with_env(cmd, env, args) do
    IO.puts "==> Running #{cmd} with `MIX_ENV=#{env}`"

    args = if cmd == "test" do ["--color"|args] else args end

    {_, res} = System.cmd "mix", [cmd|args],
      into: IO.binstream(:stdio, :line),
      env: [{"MIX_ENV", to_string(env)}]

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end
end
