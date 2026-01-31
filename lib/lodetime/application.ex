defmodule LodeTime.Application do
  @moduledoc """
  LodeTime OTP Application.

  Starts the supervision tree with all LodeTime services.
  Services are started in dependency order.
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Registry for named processes
      {Registry, keys: :unique, name: LodeTime.Registry},
      
      # PubSub for internal events
      {Phoenix.PubSub, name: LodeTime.PubSub}
      
      # Phase 1 components (uncomment as implemented):
      # LodeTime.Config.Server,
      # LodeTime.Graph.Server,
      # LodeTime.Interface.CliSocket,
      
      # Phase 2 components:
      # LodeTime.Watcher.Supervisor,
      # LodeTime.State.Server,
      # LodeTime.Runner.Supervisor,
      
      # Phase 3 components:
      # LodeTime.Interface.Notify.Router,
      # LodeTime.Interface.McpServer,
      # LodeTime.Interface.WebSocket
    ]

    # Filter out commented/unimplemented modules
    children = Enum.filter(children, fn
      {module, _} when is_atom(module) -> Code.ensure_loaded?(module)
      module when is_atom(module) -> Code.ensure_loaded?(module)
      _ -> true
    end)

    opts = [strategy: :one_for_one, name: LodeTime.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
