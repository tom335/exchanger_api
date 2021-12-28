import Config

config :mnesia, dir: 'priv/data/mnesia/#{Mix.env()}/#{node()}'

config :exchanger,
  ecto_repos: [Exchanger.Repo],
  port: 4005,
  ex_api_key: System.get_env("EX_API_ACCESS_KEY"),
  http: Exchanger.Api.HttpClient
