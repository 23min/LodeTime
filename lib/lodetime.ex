defmodule LodeTime do
  @moduledoc """
  LodeTime - A living development companion.

  LodeTime watches your codebase, understands its architecture,
  runs tests continuously, and communicates with you and AI tools.
  """

  @doc """
  Returns the current LodeTime version.
  """
  def version do
    Application.spec(:lodetime, :vsn) |> to_string()
  end

  @doc """
  Finds the .lodetime/ directory by walking up from the current directory.
  Returns nil if not found.
  """
  def lodetime_root(start_path \\ File.cwd!()) do
    find_root(start_path)
  end

  @doc """
  Returns true if running in bootstrap mode.
  """
  def bootstrap_mode? do
    case lodetime_root() do
      nil -> false
      root ->
        config_path = Path.join(root, "config.yaml")
        case YamlElixir.read_from_file(config_path) do
          {:ok, config} -> Map.get(config, "bootstrap_mode", false)
          _ -> false
        end
    end
  end

  # Walk up directory tree looking for .lodetime/
  defp find_root("/"), do: nil
  defp find_root(path) do
    lodetime_path = Path.join(path, ".lodetime")
    
    if File.dir?(lodetime_path) do
      lodetime_path
    else
      parent = Path.dirname(path)
      if parent == path, do: nil, else: find_root(parent)
    end
  end
end
