defmodule Brintex.InitTask do
  @moduledoc """
  Initializes the distributed part of the application - the ingest pipeline.
  """

  use Task, restart: :transient

  alias Brintex.Distribution
  alias Brintex.Ingest

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    Horde.DynamicSupervisor.start_child(
      Distribution.Supervisor,
      Ingest.Pipeline
    )
  end
end
