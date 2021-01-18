defmodule Brintex.Ingest.Pipeline do
  use Broadway

  require Logger

  alias Broadway.Message
  alias __MODULE__.{BroadwayHelpers, RoutingKey}

  @config Application.fetch_env!(:brintex, __MODULE__)

  def start_link(_args) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "",
           connection: connection_string(),
           declare: [exclusive: true],
           bindings: construct_bindings(),
           metadata: [:routing_key]}
      ],
      processors: [
        default: []
      ]
    )
  end

  @impl true
  def handle_message(_processor, %Message{} = message, _context) do
    message
    |> BroadwayHelpers.update_meta(&parse_routing_key/1)
    |> process_message()
  end

  defp process_message(%Message{metadata: %{routing_key: %{type: type}}, data: _data} = message) do
    Logger.debug("Processing a #{type} message")

    message
  end

  defp parse_routing_key(%{routing_key: key} = meta) do
    %{meta | routing_key: RoutingKey.from(key)}
  end

  defp connection_string() do
    Keyword.fetch!(@config, :conn_string)
  end

  defp construct_bindings() do
    @config
    |> Keyword.fetch!(:bindings)
    |> Enum.map(&{"unifiedfeed", routing_key: &1})
  end
end
