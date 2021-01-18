# Attempt at fault-tolerant data ingestion mechanism for Betradar

## Summary

A proof-of-concept for handling in a fault-tolerant manner Betradar's 
exclusive, non-durable queues using Horde and Broadway.

## Use case

Betradar is a great sports data provider which makes use of the great RabbitMQ
but unfortunately the provider allow only declaring exclusive, non-durable
queues. This means that in case of connection issues on the client side, any
missed messages are lost because when the client reconnects, a new queue is
created (exclusive, non-durable). The task to handle the connection, minimizing
the lost messages is a hard one. This repo showcases one way to handle the
eclusive, non-durable queues of Betradar with fault-tolerance in mind.

The approach requires at least two instances of the application in an Erlang
cluster. The fine [`libcluster`](https://hexdocs.pm/libcluster/) library is 
used for this proof-of-concept but it can be substituted with anything that
accomplishes the same task. Another library [`horde`](https://hexdocs.pm/horde)
for ensuring only one AMQP connection at a time exists. Remember the properties
of the queues Betradar allow. If there are more than one connection, the queues
are actually different and the messages must be deduplicated.

You can start two instances of the application using the terminal, typing the
following code. But before starting the application you should provide two
OS environment variables - BETRADAR_CONN_STRING and BETRADAR_BINDINGS. The
first variable is the full AMQPS connection string according to the formatting
rules of the AMQP protocol using your provider credentials.

```
$> iex --name a@127.0.0.1 -S mix
```

And in another tab:

```
$> iex --name b@127.0.0.1 -S mix
```

You should be able to see the pipeline working but only one of the instances
log messages to the console which means we've achieved what we wanted. If you
kill the instance which does the processing, the other instance immediately
creates an AMQP channel, declares a queue and starts processing. This approach
is much better than having a single instance and be OK with losing messages but
it's still not perfect.

## Different approaches

Another approach would be to use a CRDT to have a queue name distributed across
an Erlang cluster. That way not only there would not be duplication of messages
but the processing would be distributed. I havent explored this approach in
depth but it should be possible, albeit harder than the presented approach,
leveraging library like [`delta_crdt`](https://hexdocs.pm/delta_crd).