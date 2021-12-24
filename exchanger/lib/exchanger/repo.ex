defmodule Exchanger.Repo do
  use Ecto.Repo,
    otp_app: :exchanger_app,
    adapter: Ecto.Adapters.Mnesia
end
