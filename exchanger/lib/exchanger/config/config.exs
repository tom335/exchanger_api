import Config

import_config "#{Mix.env()}.exs"

config :exchanger, ecto_repos: [Exchanger.Repo]
