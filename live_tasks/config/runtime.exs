import Config

if config_env() == :prod do
  # Ensure SECRET_KEY_BASE is available
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      Environment variable SECRET_KEY_BASE is missing.
      You can generate one by running: mix phx.gen.secret
      """

  # Use the PORT environment variable set by Render (default to 4000 if missing)
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :live_tasks, LiveTasksWeb.Endpoint,
    url: [host: System.get_env("RENDER_EXTERNAL_HOSTNAME") || "localhost", port: 443],
    http: [ip: {0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base,
    server: true,
    check_origin: false,
    cache_static_manifest: "priv/static/cache_manifest.json"

  # Configure logger for production
  config :logger, level: :info
end
