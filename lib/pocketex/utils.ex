defmodule Pocketex.Utils do
  @moduledoc """
  Generic utility functions for Pocketex
  """

  @doc """
  Converts an option name from Elixir's underscore_notation to Pocket's bumpyCase
  """
  @spec underscore_to_bumpy(String.t) :: String.t

  def underscore_to_bumpy(string) do
    [head|tail] = String.split(string, "_")
    rest = Enum.map_join(tail, &(String.capitalize &1) )

    head <> rest
  end
end
