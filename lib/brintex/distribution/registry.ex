defmodule Brintex.Distribution.Registry do
  @moduledoc false

  def child_spec(_args) do
    Horde.Registry.child_spec(
      name: __MODULE__,
      keys: :unique,
      members: :auto
    )
  end

  def via(identifier) do
    {:via, Horde.Registry, {__MODULE__, identifier}}
  end
end
