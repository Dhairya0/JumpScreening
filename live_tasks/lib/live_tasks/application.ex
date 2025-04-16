defmodule LiveTasks.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveTasksWeb.Telemetry,
      # ❌ Removed: LiveTasks.Repo,
      {DNSCluster, query: Application.get_env(:live_tasks, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveTasks.PubSub},
      {Finch, name: LiveTasks.Finch},
      LiveTasksWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LiveTasks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    LiveTasksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
