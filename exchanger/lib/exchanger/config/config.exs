config :ecto3_mnesia,
  host: {:system, :atom, "MNESIA_HOST", node()},
  storage_type: {:system, :atom, "MNESIA_STORAGE_TYPE", :disc_copies}

config :exchanger, ecto_repos: [Exchanger.Repo]

config :mnesia,
  dir: 'priv/data/mnesia'
