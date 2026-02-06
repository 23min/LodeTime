defmodule LodeTime.Config.LoaderTest do
  use ExUnit.Case

  alias LodeTime.Config.Loader
  alias LodeTime.Config.{Error, Model}

  describe "load/1" do
    test "loads configuration from repo .lodetime directory" do
      root = File.cwd!()

      assert {:ok, %Model{} = model} = Loader.load(root)
      assert is_map(model.config)
      assert map_size(model.components) > 0
      assert map_size(model.contracts) > 0
    end

    test "returns error for missing config.yaml" do
      root = tmp_dir()
      write_components(root)
      write_contracts(root)

      assert {:error, errors} = Loader.load(root)
      assert has_error?(errors, "config.yaml", nil)
    end

    test "returns error for malformed YAML" do
      root = tmp_dir()
      write_config(root, "project: [")
      write_components(root)
      write_contracts(root)

      assert {:error, errors} = Loader.load(root)
      assert has_error?(errors, "config.yaml", nil)
    end

    test "returns error for missing required config fields" do
      root = tmp_dir()
      write_config(root, "schema_version: 1\ncurrent_phase: 1\nzones: {}\n")
      write_components(root)
      write_contracts(root)

      assert {:error, errors} = Loader.load(root)
      assert has_error?(errors, "config.yaml", "project")
    end

    test "returns error for missing required component fields" do
      root = tmp_dir()
      write_config(root)
      write_components(root, "id: config-loader\nschema_version: 1\nstatus: planned\nlocation: lib/lodetime/config/\ndepends_on: []\n")
      write_contracts(root)

      assert {:error, errors} = Loader.load(root)
      assert has_error?(errors, "components/config-loader.yaml", "name")
    end

    test "returns error for missing required contract fields" do
      root = tmp_dir()
      write_config(root)
      write_components(root)
      write_contracts(root, "id: graph-api\nschema_version: 1\nname: Graph API\n")

      assert {:error, errors} = Loader.load(root)
      assert has_error?(errors, "contracts/graph-api.yaml", "description")
    end
  end

  defp tmp_dir do
    dir = Path.join(System.tmp_dir!(), "lodetime-test-#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    dir
  end

  defp write_config(root, contents \\ default_config()) do
    lodetime = Path.join(root, ".lodetime")
    File.mkdir_p!(lodetime)
    File.write!(Path.join(lodetime, "config.yaml"), contents)
  end

  defp write_components(root, contents \\ default_component()) do
    dir = Path.join([root, ".lodetime", "components"])
    File.mkdir_p!(dir)
    File.write!(Path.join(dir, "config-loader.yaml"), contents)
  end

  defp write_contracts(root, contents \\ default_contract()) do
    dir = Path.join([root, ".lodetime", "contracts"])
    File.mkdir_p!(dir)
    File.write!(Path.join(dir, "graph-api.yaml"), contents)
  end

  defp default_config do
    """
    project: test
    schema_version: 1
    current_phase: 1
    zones:
      core:
        paths: [lib/]
        tracking: full
    """
  end

  defp default_component do
    """
    id: config-loader
    schema_version: 1
    name: Config Loader
    status: planned
    location: lib/lodetime/config/
    depends_on: []
    """
  end

  defp default_contract do
    """
    id: graph-api
    schema_version: 1
    name: Graph API
    description: Test contract
    """
  end

  defp has_error?(errors, file, field) do
    Enum.any?(errors, fn
      %Error{file: ^file, field: ^field} -> true
      _ -> false
    end)
  end
end
