defmodule PhoenixPubsubLaspPgTest do
  use ExUnit.Case
  doctest PhoenixPubsubLaspPg
  Application.put_env(:phoenix, :pubsub_test_adapter, Phoenix.PubSub.LaspPG)
  Code.require_file("../deps/phoenix_pubsub/test/shared/pubsub_test.exs", __DIR__)
end
