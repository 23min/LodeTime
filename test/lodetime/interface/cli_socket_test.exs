defmodule LodeTime.Interface.CliSocketTest do
  use ExUnit.Case

  alias LodeTime.Interface.CliSocket

  defmodule TestGraphServer do
    def status_payload do
      %{
        mode: "connected",
        runtime_state: "running",
        phase: 1,
        graph: %{component_count: 2, contract_count: 1},
        last_error: %{count: 0},
        runtime_version: "test"
      }
    end
  end

  test "status returns payload" do
    log_path = Path.join(System.tmp_dir!(), "lodetime-cli-socket.log")
    {:ok, pid} = CliSocket.start_link(port: 0, graph_server: TestGraphServer, log_path: log_path)
    {:ok, {_, port}} = ThousandIsland.listener_info(pid)

    {:ok, socket} = :gen_tcp.connect({127, 0, 0, 1}, port, [:binary, active: false])
    :ok = :gen_tcp.send(socket, Jason.encode!(%{cmd: "status", verbose: false}) <> "\n")
    {:ok, resp} = :gen_tcp.recv(socket, 0, 1000)

    data = Jason.decode!(resp)
    assert data["ok"] == true
    assert data["data"]["graph"]["component_count"] == 2
    assert File.exists?(log_path)

    :gen_tcp.close(socket)
    Supervisor.stop(pid)
  end

  test "unknown command returns error" do
    {:ok, pid} = CliSocket.start_link(port: 0, graph_server: TestGraphServer)
    {:ok, {_, port}} = ThousandIsland.listener_info(pid)

    {:ok, socket} = :gen_tcp.connect({127, 0, 0, 1}, port, [:binary, active: false])
    :ok = :gen_tcp.send(socket, Jason.encode!(%{cmd: "nope"}) <> "\n")
    {:ok, resp} = :gen_tcp.recv(socket, 0, 1000)

    data = Jason.decode!(resp)
    assert data["ok"] == false
    assert data["error"]["code"] == "not_implemented"

    :gen_tcp.close(socket)
    Supervisor.stop(pid)
  end
end
