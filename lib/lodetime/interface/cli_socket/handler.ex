defmodule LodeTime.Interface.CliSocket.Handler do
  @moduledoc false

  use ThousandIsland.Handler

  alias ThousandIsland.Socket

  @impl ThousandIsland.Handler
  def handle_data(data, socket, state) do
    buffer = (state[:buffer] || "") <> IO.iodata_to_binary(data)
    {lines, rest} = split_lines(buffer)

    Enum.each(lines, fn line ->
      handle_line(String.trim(line), socket, state)
    end)

    {:continue, Map.put(state, :buffer, rest)}
  end

  defp split_lines(buffer) do
    parts = String.split(buffer, "\n")
    case parts do
      [] -> {[], ""}
      _ -> {Enum.drop(parts, -1), List.last(parts)}
    end
  end

  defp handle_line("", _socket, _state), do: :ok

  defp handle_line(line, socket, state) do
    case Jason.decode(line) do
      {:ok, %{"cmd" => "status"} = req} ->
        verbose = Map.get(req, "verbose", false)
        data = status_payload(state[:graph_server], verbose)
        send_response(socket, %{ok: true, data: data})

      {:ok, %{"cmd" => _cmd}} ->
        send_error(socket, "not_implemented", "command not implemented")

      {:error, _} ->
        send_error(socket, "invalid_json", "invalid JSON")
    end
  end

  defp status_payload(nil, _verbose), do: %{}
  defp status_payload(graph_server, _verbose) do
    if function_exported?(graph_server, :status_payload, 0) do
      graph_server.status_payload()
    else
      graph_server.summary()
    end
  end

  defp send_response(socket, payload) do
    Socket.send(socket, Jason.encode!(payload) <> "\n")
  end

  defp send_error(socket, code, message) do
    send_response(socket, %{ok: false, error: %{code: code, message: message}})
  end
end
