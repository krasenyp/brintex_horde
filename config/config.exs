import Config

config :brintex, Brintex.Ingest.Pipeline,
  conn_string: System.get_env("BETRADAR_CONN_STRING", ""),
  bindings:
    System.get_env("BETRADAR_BINDINGS", "") |> String.split(",") |> Enum.map(&String.trim/1)
