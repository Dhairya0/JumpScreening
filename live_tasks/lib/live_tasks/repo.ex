defmodule LiveTasks.Repo do
  use Ecto.Repo,
    otp_app: :live_tasks,
    adapter: Ecto.Adapters.Postgres
end
