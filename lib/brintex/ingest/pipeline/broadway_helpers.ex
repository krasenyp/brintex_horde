defmodule Brintex.Ingest.Pipeline.BroadwayHelpers do
  @moduledoc """
  Helper functions for working with Broadway Message structs.
  """

  alias Broadway.Message

  @doc """
  Similar in idea to [`update_data`](https://hexdocs.pm/broadway/Broadway.Message.html#update_data/2)
  but instead of updating the data of a message this function updates the
  metadata of the provided message.
  """
  @spec update_meta(Message.t(), (any -> any)) :: Message.t()
  def update_meta(%Message{metadata: meta} = message, fun) do
    %Message{message | metadata: fun.(meta)}
  end
end
