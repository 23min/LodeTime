defmodule LodeTime.Graph.ServerTest do
  use ExUnit.Case

  alias LodeTime.Graph.Server

  describe "summarize/1" do
    test "returns counts for components and contracts" do
      data = %{
        components: %{"config-loader" => %{}, "graph-server" => %{}},
        contracts: %{"graph-api" => %{}}
      }

      assert %{component_count: 2, contract_count: 1} = Server.summarize(data)
    end
  end

  describe "start_link/1" do
    test "loads config and returns summary" do
      root = tmp_dir()
      write_config(root)
      write_components(root)
      write_contracts(root)

      log_path = Path.join(root, "logs/graph-server/runtime.log")
      assert {:ok, pid} = Server.start_link(root_path: root, name: nil, log_path: log_path)
      assert %{component_count: 1, contract_count: 1} = Server.summary(pid)
      Logger.flush()
      assert File.exists?(log_path)
      assert %{degraded: false, last_good_at: %DateTime{}} = Server.status(pid)
      GenServer.stop(pid)
    end

    test "starts in degraded mode on invalid config" do
      root = tmp_dir()
      File.mkdir_p!(Path.join(root, ".lodetime"))

      assert {:ok, pid} = Server.start_link(root_path: root, name: nil)
      assert %{degraded: true, last_good_at: nil, last_error: errors} = Server.status(pid)
      assert Enum.any?(errors, &match?(%LodeTime.Config.Error{file: "config.yaml"}, &1))
      GenServer.stop(pid)
    end
  end

  describe "reload/1" do
    test "preserves last known good graph on failure" do
      root = tmp_dir()
      write_config(root)
      write_components(root)
      write_contracts(root)

      assert {:ok, pid} = Server.start_link(root_path: root, name: nil)
      assert %{component_count: 1, contract_count: 1} = Server.summary(pid)

      File.rm!(Path.join([root, ".lodetime", "config.yaml"]))
      assert {:error, errors} = Server.reload(pid)
      assert Enum.any?(errors, &match?(%LodeTime.Config.Error{file: "config.yaml"}, &1))
      assert %{degraded: true, last_good_at: %DateTime{}} = Server.status(pid)
      assert %{component_count: 1, contract_count: 1} = Server.summary(pid)
      GenServer.stop(pid)
    end
  end

  defp tmp_dir do
    dir = Path.join(System.tmp_dir!(), "lodetime-test-#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    dir
  end

  defp write_config(root) do
    lodetime = Path.join(root, ".lodetime")
    File.mkdir_p!(lodetime)
    File.write!(
      Path.join(lodetime, "config.yaml"),
      "project: test\nschema_version: 1\ncurrent_phase: 1\nzones:\n  core:\n    paths: [lib/]\n    tracking: full\n"
    )
  end

  defp write_components(root) do
    dir = Path.join([root, ".lodetime", "components"])
    File.mkdir_p!(dir)
    File.write!(
      Path.join(dir, "config-loader.yaml"),
      "id: config-loader\nschema_version: 1\nname: Config Loader\nstatus: planned\nlocation: lib/lodetime/config/\ndepends_on: []\n"
    )
  end

  defp write_contracts(root) do
    dir = Path.join([root, ".lodetime", "contracts"])
    File.mkdir_p!(dir)
    File.write!(
      Path.join(dir, "graph-api.yaml"),
      "id: graph-api\nschema_version: 1\nname: Graph API\ndescription: Test contract\n"
    )
  end
end
