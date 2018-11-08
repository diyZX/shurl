defmodule Shurl.Util do
  def map_to_keyword_list(map) when is_map(map) do
    map |> Enum.map(fn {k, v} -> {"#{k}" |> String.to_atom, v} end)
  end
end
