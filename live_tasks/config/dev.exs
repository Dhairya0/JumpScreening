import Config

# ❌ REMOVE or COMMENT this block
# config :live_tasks, LiveTasks.Repo,
#   username: "postgres",
#   password: "postgres",
#   hostname: "localhost",
#   database: "live_tasks_dev",
#   stacktrace: true,
#   show_sensitive_data_on_connection_error: true,
#   pool_size: 10

# App server config
config :live_tasks, LiveTasksWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "iQKVmCVlBKWCtrGHVNtCB+DJCTZest8nJOVbFSjX1XnWf20XjEVloTNcpMLbh8Ro",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:live_tasks, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:live_tasks, ~w(--watch)]}
  ]

# Live reload config
config :live_tasks, LiveTasksWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/live_tasks_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :live_tasks, dev_routes: true
config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false
