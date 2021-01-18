defmodule Brintex.Application do
  use Application

  alias Brintex.Distribution

  @impl true
  def start(_type, _args) do
    children = [
      Distribution.Cluster,
      Distribution.Registry,
      Distribution.Supervisor,
      Brintex.InitTask
    ]

    opts = [strategy: :one_for_one, name: Brintex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
