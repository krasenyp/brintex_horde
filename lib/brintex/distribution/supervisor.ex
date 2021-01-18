defmodule Brintex.Distribution.Supervisor do
  @moduledoc false

  def child_spec(_arg) do
    Horde.DynamicSupervisor.child_spec(
      name: __MODULE__,
      strategy: :one_for_one,
      members: :auto
    )
  end
end
