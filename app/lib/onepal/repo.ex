defmodule Onepal.Repo do
  use Ecto.Repo,
    otp_app: :onepal,
    adapter: Ecto.Adapters.Postgres
end
