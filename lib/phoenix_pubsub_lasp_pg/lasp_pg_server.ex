defmodule Phoenix.PubSub.LaspPGServer do
  use GenServer
  alias Phoenix.PubSub.Local

  def init({server_name, pool_size}) do
    lasp_pg_group = lasp_pg_namespace(server_name)
    {:ok, value} = :lasp_pg.join(lasp_pg_group, self())
    {:ok, %{name: server_name, pool_size: pool_size}}
  end

  def start_link(server_name, pool_size) do
    GenServer.start_link(__MODULE__, {server_name, pool_size}, name: server_name)
  end

  def direct_broadcast(fastlane, server_name, pool_size, node_name, from_pid, topic, msg) do
    server_name
    |> get_members(node_name)
    |> do_broadcast(fastlane, server_name, pool_size, from_pid, topic, msg)
  end

  def broadcast(fastlane, server_name, pool_size, from_pid, topic, msg) do
    server_name
    |> get_members()
    |> do_broadcast(fastlane, server_name, pool_size, from_pid, topic, msg)
  end

  def handle_info({:forward_to_local, fastlane, from_pid, topic, msg}, state) do
    Local.broadcast(fastlane, state.name, state.pool_size, from_pid, topic, msg)
    {:noreply, state}
  end

  defp get_members(server_name) do
    {:ok, members} = :lasp_pg.members(lasp_pg_namespace(server_name))
    :sets.to_list(members)
  end

  defp get_members(server_name, node_name) do
    [{server_name, node_name}]
  end

  defp do_broadcast([], _fastlane, _server, _pool, _from, _topic, _msg) do
    {:error, :no_such_group}
  end

  defp do_broadcast(pids, fastlane, server_name, pool_size, from_pid, topic, msg)
       when is_list(pids) do
    local_node = Phoenix.PubSub.node_name(server_name)

    Enum.each(pids, fn
      pid when is_pid(pid) and node(pid) == node() ->
        Local.broadcast(fastlane, server_name, pool_size, from_pid, topic, msg)

      {^server_name, node_name} when node_name == local_node ->
        Local.broadcast(fastlane, server_name, pool_size, from_pid, topic, msg)

      pid_or_tuple ->
        send(pid_or_tuple, {:forward_to_local, fastlane, from_pid, topic, msg})
    end)

    :ok
  end

  defp lasp_pg_namespace(server_name), do: {:phx, server_name}
end
