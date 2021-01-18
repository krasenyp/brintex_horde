defmodule Brintex.Ingest.Pipeline.RoutingKey do
  @moduledoc """
  Defines a struct with fields corresponding to the fields in a Betradar AMQP
  message's routing key.
  """

  @keys ~w(priority pre_match_interest live_interest type sport urn id node_id)a

  @type t :: %__MODULE__{
          priority: String.t(),
          pre_match_interest: String.t(),
          live_interest: String.t(),
          type: String.t(),
          sport: String.t(),
          urn: String.t(),
          id: String.t(),
          node_id: String.t()
        }

  defstruct @keys

  @spec from(binary()) :: __MODULE__.t()
  def from(str) when is_binary(str) do
    str
    |> String.split(".")
    |> Enum.map(&nillify_dash/1)
    |> Enum.zip(@keys)
    |> Enum.map(&flip_pair/1)
    |> Enum.into(%__MODULE__{})
  end

  defp nillify_dash("-"), do: nil
  defp nillify_dash(s), do: s

  defp flip_pair({a, b}), do: {b, a}

  defimpl Collectable do
    def into(original) do
      collector_fun = fn
        sct, {:cont, [key, val]} -> Map.put(sct, key, val)
        sct, {:cont, {key, val}} -> Map.put(sct, key, val)
        sct, :done -> sct
        _sct, :halt -> :ok
      end

      {original, collector_fun}
    end
  end
end
