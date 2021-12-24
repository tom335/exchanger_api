defmodule Exchanger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        Plug.Cowboy,
        plug: Exchanger.Router,
        scheme: :http,
        options: [port: 4003]
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