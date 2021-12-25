defmodule Exchanger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # apparently the Ecto Mnesia Adapter creates a
    # connection without using the config.exs :mnesia setting,
    # so we're adding here the mnesia data dir; maybe this
    # configuration only works in runtime?
    Application.put_env(:mnesia, :dir, 'priv/data/mnesia/#{Mix.env()}/#{node()}')

    children = [
      {
        Plug.Cowboy,
        plug: Exchanger.Router, scheme: :http, options: [port: 4003]
      },
      Exchanger.Repo,
      {Finch, name: ExFinch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exchanger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
