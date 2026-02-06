defmodule LodeTime.Interface.CliSocket do
  @moduledoc false

  alias LodeTime.Interface.CliSocket.{Handler, LogSink}

  @default_port 9998
  @default_ip {127, 0, 0, 1}
  @log_path "logs/cli-socket/runtime.log"

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(opts \\ []) do
    port = Keyword.get(opts, :port, @default_port)
    ip = Keyword.get(opts, :ip, @default_ip)
    graph_server = Keyword.get(opts, :graph_server, LodeTime.Graph.Server)
    log_path = Keyword.get(opts, :log_path, @log_path)

    attach_logger(log_path)

    ThousandIsland.start_link(
      port: port,
      transport_options: [ip: ip],
      handler_module: Handler,
      handler_options: %{graph_server: graph_server, buffer: ""}
    )
  end

  defp attach_logger(log_path) do
    File.mkdir_p!(Path.dirname(log_path))
    File.write!(log_path, "", [:append])

    case Logger.add_backend({LogSink, log_path}) do
      {:error, {:already_present, _}} -> :ok
      _ -> :ok
    end
  end
end
