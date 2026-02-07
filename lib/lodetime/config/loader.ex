defmodule LodeTime.Config.Loader do
  @moduledoc """
  Loads `.lodetime/` configuration files into a validated model.

  Returns `{:ok, %LodeTime.Config.Model{}}` on success or
  `{:error, [%LodeTime.Config.Error{}]}` on failure.
  """

  alias LodeTime.Config.{Error, Model}

  @config_required ["project", "schema_version", "current_phase", "zones"]
  @component_required ["id", "schema_version", "name", "status", "location", "depends_on"]
  @contract_required ["id", "schema_version", "name", "description"]

  @spec load(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) ::
          {:error, any()}
          | {:ok, %LodeTime.Config.Model{components: any(), config: any(), contracts: any()}}
  @spec load(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) ::
          {:error, any()}
          | {:ok, %LodeTime.Config.Model{components: any(), config: any(), contracts: any()}}
  @doc """
  Load configuration from the repo root.
  """
  def load(root_path) do
    lodetime_dir = Path.join(root_path, ".lodetime")

    if File.dir?(lodetime_dir) do
      {config, errors} = load_config(lodetime_dir)
      {components, errors} = load_collection(lodetime_dir, "components", @component_required, errors)
      {contracts, errors} = load_collection(lodetime_dir, "contracts", @contract_required, errors)

      if errors == [] do
        {:ok, %Model{config: config, components: components, contracts: contracts}}
      else
        {:error, errors}
      end
    else
      {:error, [%Error{file: ".lodetime", field: nil, message: "missing .lodetime directory"}]}
    end
  end

  defp load_config(lodetime_dir) do
    path = Path.join(lodetime_dir, "config.yaml")
    case load_yaml(path) do
      {:ok, data} ->
        errors = validate_fields("config.yaml", data, @config_required)
        {data, errors}

      {:error, error} ->
        {nil, [error]}
    end
  end

  defp load_collection(lodetime_dir, subdir, required_fields, errors) do
    dir = Path.join(lodetime_dir, subdir)

    if File.dir?(dir) do
      {items, errors} =
        dir
        |> File.ls!()
        |> Enum.filter(&String.ends_with?(&1, ".yaml"))
        |> Enum.reduce({%{}, errors}, fn file, {acc, errs} ->
          path = Path.join(dir, file)
          rel = Path.join(subdir, file)

          case load_yaml(path, rel) do
            {:ok, data} ->
              field_errors = validate_fields(rel, data, required_fields)
              id = Map.get(data, "id")
              acc = if id, do: Map.put(acc, id, data), else: acc
              {acc, errs ++ field_errors}

            {:error, error} ->
              {acc, errs ++ [error]}
          end
        end)

      {items, errors}
    else
      { %{}, errors }
    end
  end

  defp load_yaml(path, rel \\ nil) do
    if File.exists?(path) do
      case YamlElixir.read_from_file(path) do
        {:ok, data} -> {:ok, data}
        {:error, error} -> {:error, %Error{file: rel || Path.basename(path), field: nil, message: error.message}}
      end
    else
      {:error, %Error{file: rel || Path.basename(path), field: nil, message: "missing file"}}
    end
  end

  defp validate_fields(file, data, required_fields) when is_map(data) do
    Enum.reduce(required_fields, [], fn field, errors ->
      if Map.has_key?(data, field) do
        errors
      else
        errors ++ [%Error{file: file, field: field, message: "missing required field"}]
      end
    end)
  end

  defp validate_fields(file, _data, _required_fields) do
    [%Error{file: file, field: nil, message: "invalid yaml structure"}]
  end
end
