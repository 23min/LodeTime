defmodule LodeTime.Interface.CliSocket.LogSink do
  @moduledoc false

  @behaviour :gen_event

  def init(path) do
    File.mkdir_p!(Path.dirname(path))
    {:ok, %{path: path}}
  end

  def handle_event({:log, level, msg, _ts, _md}, state) do
    line = "#{level} #{IO.iodata_to_binary(msg)}\n"
    File.write!(state.path, line, [:append])
    {:ok, state}
  end

  def handle_event(_, state), do: {:ok, state}
  def handle_call(_, state), do: {:ok, :ok, state}
  def handle_info(_, state), do: {:ok, state}
  def terminate(_, _), do: :ok
  def code_change(_, state, _), do: {:ok, state}
end
