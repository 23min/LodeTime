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

  def status(server \\ __MODULE__) do
    GenServer.call(server, :status)
  end

  def reload(server \\ __MODULE__) do
    GenServer.call(server, :reload)
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

    case load_graph(root_path) do
      {:ok, graph} ->
        now = DateTime.utc_now()
        {:ok,
         Map.merge(state, %{
           graph: graph,
           last_good_graph: graph,
           last_good_at: now,
           last_error: nil,
           degraded: false
         })}

      {:error, errors} ->
        {:ok,
         Map.merge(state, %{
           graph: empty_graph(),
           last_good_graph: nil,
           last_good_at: nil,
           last_error: errors,
           degraded: true
         })}
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
    graph = graph_for_summary(state)
    {:reply, summarize(graph), state}
  end

  @impl true
  def handle_call(:status, _from, state) do
    {:reply,
     %{
       degraded: state.degraded,
       last_good_at: state.last_good_at,
       last_error: state.last_error
     }, state}
  end

  @impl true
  def handle_call(:reload, _from, state) do
    case load_graph(state.root_path) do
      {:ok, graph} ->
        now = DateTime.utc_now()
        new_state = %{
          state
          | graph: graph,
            last_good_graph: graph,
            last_good_at: now,
            last_error: nil,
            degraded: false
        }

        {:reply, :ok, new_state}

      {:error, errors} ->
        new_state = %{
          state
          | graph: graph_for_summary(state),
            last_error: errors,
            degraded: true
        }

        {:reply, {:error, errors}, new_state}
    end
  end

  defp load_graph(root_path) do
    case Loader.load(root_path) do
      {:ok, model} ->
        {:ok, %{components: model.components, contracts: model.contracts}}

      {:error, errors} ->
        {:error, errors}
    end
  end

  defp empty_graph do
    %{components: %{}, contracts: %{}}
  end

  defp graph_for_summary(%{degraded: true, last_good_graph: graph}) when is_map(graph), do: graph
  defp graph_for_summary(state), do: state.graph
end
