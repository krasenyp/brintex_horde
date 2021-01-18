defmodule Brintex.Distribution.Cluster do
  @moduledoc false

  def child_spec(_args) do
    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]

    Cluster.Supervisor.child_spec([topologies, [name: __MODULE__]])
  end
end
