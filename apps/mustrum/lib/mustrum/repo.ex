defmodule Mustrum.Repo do
  use Ecto.Repo,
    otp_app: :mustrum,
    adapter: Ecto.Adapters.Postgres
end
