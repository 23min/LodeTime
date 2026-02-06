defmodule LodeTime.Config.Error do
  @moduledoc """
  Structured config error with source file, field, and message.
  """

  defstruct file: nil, field: nil, message: nil
end
