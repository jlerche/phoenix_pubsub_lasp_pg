defmodule Phoenix.PubSub.LaspPG do
  use Supervisor

  def child_spec(opts) when is_list(opts) do
    _name = name!(opts)

    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  def start_link(opts) when is_list(opts) do
    start_link(name!(opts), opts)
  end

  def start_link(name, opts) do
    supervisor_name = Module.concat(name, Supervisor)
    Supervisor.start_link(__MODULE__, [name, opts], name: supervisor_name)
  end

  def init([server, opts]) do
    scheduler_count = :erlang.system_info(:schedulers)
    pool_size = Keyword.get(opts, :pool_size, scheduler_count)
    node_name = opts[:node_name]

    dispatch_rules = [
      {:broadcast, Phoenix.PubSub.LaspPGServer, [opts[:fastlane], server, pool_size]},
      {:direct_broadcast, Phoenix.PubSub.LaspPGServer, [opts[:fastlane], server, pool_size]},
      {:node_name, __MODULE__, [node_name]}
    ]

    children = [
      supervisor(Phoenix.PubSub.LocalSupervisor, [server, pool_size, dispatch_rules]),
      worker(Phoenix.PubSub.LaspPGServer, [server, pool_size])
    ]

    supervise(children, strategy: :rest_for_one)
  end

  def node_name(nil), do: node()
  def node_name(configured_name), do: configured_name

  defp name!(opts) do
    case Keyword.fetch(opts, :name) do
      {:ok, name} ->
        name

      :error ->
        raise ArgumentError, "registered name is required"
    end
  end
end
