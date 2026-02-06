defmodule LodeTime.Graph.Server do
  @moduledoc false

  use GenServer

  alias LodeTime.Config.Loader
  alias LodeTime.Graph.LogSink

  @log_path "logs/graph-server/runtime.log"

  @spec start_link() :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(opts \\ []) do
    root_path = Keyword.get(opts, :root_path, File.cwd!())
    name = Keyword.get(opts, :name, __MODULE__)
    log_path = Keyword.get(opts, :log_path, @log_path)

    start_opts =
      case name do
        nil -> []
        _ -> [name: name]
      end

    GenServer.start_link(__MODULE__, %{root_path: root_path, log_path: log_path}, start_opts)
  end

  @spec summary() :: any()
  def summary(server \\ __MODULE__) do
    GenServer.call(server, :summary)
  end

  def summarize(%{components: components, contracts: contracts})
      when is_map(components) and is_map(contracts) do
    %{
      component_count: map_size(components),
      contract_count: map_size(contracts)
    }
  end

  @impl true
  def init(%{root_path: root_path, log_path: log_path} = state) do
    attach_logger(log_path)
    require Logger
    Logger.info("Graph server starting")
    case Loader.load(root_path) do
      {:ok, model} ->
        graph = %{components: model.components, contracts: model.contracts}
        {:ok, Map.merge(state, %{model: model, graph: graph})}

      {:error, errors} ->
        {:stop, {:config_error, errors}}
    end
  end

  defp attach_logger(log_path) do
    File.mkdir_p!(Path.dirname(log_path))
    File.write!(log_path, "", [:append])
    case Logger.add_backend({LogSink, log_path}) do
      {:error, {:already_present, _}} -> :ok
      _ -> :ok
    end
  end

  @impl true
  def handle_call(:summary, _from, state) do
    {:reply, summarize(state.graph), state}
  end
end
