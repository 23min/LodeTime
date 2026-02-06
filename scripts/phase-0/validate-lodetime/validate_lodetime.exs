#!/usr/bin/env elixir

defmodule Phase0.ValidateLodeTime do
  @config_required ~w(project schema_version current_phase)a
  @component_required ~w(id name status location depends_on)a
  @contract_required ~w(id name description)a

  def run do
    repo_root = System.argv() |> List.first() |> normalize_root()
    lodetime_root = Path.join(repo_root, ".lodetime")

    with [] <- check_required_paths(lodetime_root),
         {:ok, config} <- load_yaml(Path.join(lodetime_root, "config.yaml")),
         config_errors <- validate_required_keys(config, @config_required, "config.yaml"),
         {:ok, component_records, component_errors} <- load_records(Path.join(lodetime_root, "components"), @component_required, "components"),
         {:ok, contract_records, contract_errors} <- load_records(Path.join(lodetime_root, "contracts"), @contract_required, "contracts") do
      component_ids = MapSet.new(Enum.map(component_records, & &1.id))
      contract_ids = MapSet.new(Enum.map(contract_records, & &1.id))

      errors =
        []
        |> Kernel.++(config_errors)
        |> Kernel.++(component_errors)
        |> Kernel.++(contract_errors)
        |> Kernel.++(duplicate_id_errors(component_records, "component"))
        |> Kernel.++(duplicate_id_errors(contract_records, "contract"))
        |> Kernel.++(reference_errors(component_records, component_ids, contract_ids))

      case errors do
        [] ->
          IO.puts("PASS: .lodetime validation succeeded")
          IO.puts("  components: #{length(component_records)}")
          IO.puts("  contracts: #{length(contract_records)}")
          System.halt(0)

        _ ->
          IO.puts("FAIL: .lodetime validation found #{length(errors)} issue(s)")
          Enum.each(errors, &IO.puts("  - " <> &1))
          System.halt(1)
      end
    else
      missing when is_list(missing) and missing != [] ->
        IO.puts("FAIL: missing required path(s)")
        Enum.each(missing, &IO.puts("  - " <> &1))
        System.halt(1)

      {:error, reason} ->
        IO.puts("FAIL: #{reason}")
        System.halt(1)
    end
  end

  defp normalize_root(nil), do: File.cwd!()
  defp normalize_root(path), do: Path.expand(path)

  defp check_required_paths(lodetime_root) do
    required = [
      Path.join(lodetime_root, "config.yaml"),
      Path.join(lodetime_root, "components"),
      Path.join(lodetime_root, "contracts")
    ]

    Enum.reduce(required, [], fn path, missing ->
      if File.exists?(path), do: missing, else: [path | missing]
    end)
    |> Enum.reverse()
  end

  defp load_records(dir, required_keys, label) do
    paths = Path.wildcard(Path.join(dir, "*.yaml")) |> Enum.sort()

    if paths == [] do
      {:error, "no #{label} files found under #{dir}"}
    else
      result =
        Enum.reduce(paths, %{records: [], errors: []}, fn path, acc ->
          case load_yaml(path) do
            {:ok, map} ->
              map_errors = validate_required_keys(map, required_keys, Path.basename(path))
              id = map["id"]
              records = [%{path: path, id: id, data: map} | acc.records]
              %{acc | records: records, errors: acc.errors ++ map_errors}

            {:error, reason} ->
              %{acc | errors: acc.errors ++ ["#{Path.basename(path)}: #{reason}"]}
          end
        end)

      {:ok, Enum.reverse(result.records), result.errors}
    end
  end

  defp load_yaml(path) do
    case YamlElixir.read_from_file(path) do
      {:ok, map} when is_map(map) -> {:ok, map}
      {:ok, _value} -> {:error, "not a YAML mapping"}
      {:error, reason} -> {:error, "YAML parse error (#{inspect(reason)})"}
    end
  end

  defp validate_required_keys(map, required_keys, label) do
    Enum.reduce(required_keys, [], fn key, errors ->
      key_s = Atom.to_string(key)

      if Map.has_key?(map, key_s) do
        errors
      else
        errors ++ ["#{label}: missing required key `#{key_s}`"]
      end
    end)
  end

  defp duplicate_id_errors(records, label) do
    records
    |> Enum.group_by(& &1.id)
    |> Enum.reduce([], fn {id, grouped}, acc ->
      case {id, grouped} do
        {nil, [_ | _]} ->
          acc ++ ["#{label} file(s) missing `id`: #{Enum.map_join(grouped, ", ", &Path.basename(&1.path))}"]

        {_, [first, second | rest]} ->
          all = [first, second | rest]
          acc ++ ["duplicate #{label} id `#{first.id}` in #{Enum.map_join(all, ", ", &Path.basename(&1.path))}"]

        _ ->
          acc
      end
    end)
  end

  defp reference_errors(component_records, component_ids, contract_ids) do
    Enum.reduce(component_records, [], fn record, errors ->
      depends_on = normalize_list(record.data["depends_on"])
      implements_contracts = normalize_list(record.data["implements_contracts"])

      dep_errors =
        Enum.reduce(depends_on, [], fn dep, acc ->
          if MapSet.member?(component_ids, dep) do
            acc
          else
            acc ++ ["#{Path.basename(record.path)}: unknown depends_on component `#{dep}`"]
          end
        end)

      contract_errors =
        Enum.reduce(implements_contracts, [], fn contract_id, acc ->
          if MapSet.member?(contract_ids, contract_id) do
            acc
          else
            acc ++ ["#{Path.basename(record.path)}: unknown contract `#{contract_id}` in implements_contracts"]
          end
        end)

      errors ++ dep_errors ++ contract_errors
    end)
  end

  defp normalize_list(nil), do: []
  defp normalize_list(value) when is_list(value), do: value
  defp normalize_list(_value), do: []
end

Phase0.ValidateLodeTime.run()
