defmodule LodeTime.Config.Model do
  @moduledoc """
  In-memory configuration model for runtime and CLI consumers.
  """

  defstruct config: %{}, components: %{}, contracts: %{}
end
