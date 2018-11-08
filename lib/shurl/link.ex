defmodule Shurl.Link do
  @enforce_keys [:url, :short_code]
  alias __MODULE__
  defstruct(
    url: nil,
    short_code: nil,
    dynamic_params: [],
    is_expired?: false
  )

  @token_regex ~r/<%(\w*)%>/U

  def collect_link(%{url: url, params: params}) do
    case validate_url(url) do
      {:error, _} ->
        {:error, :invalid_url}
      {:ok, url} ->
        dynamic_params =
          Regex.scan(@token_regex, url)
          |> Enum.map(fn [_, p] -> p end)
        updated_url = Enum.reduce(dynamic_params, url,
          fn dp, acc -> Regex.replace(~r/<%#{dp}%>/, acc, params[dp] || "<%#{dp}%>") end)
        link = %Link{
          url: updated_url,
          short_code: generate_short_code(url),
          dynamic_params: dynamic_params
        }

        {:ok, link}
    end
  end
  def collect_link(%{url: url}),
    do: collect_link(%{url: url, params: %{}})

  def validate_url(url) do
    case URI.parse(url) do
      %URI{scheme: nil} ->
        {:error, :no_scheme}
      %URI{host: nil} ->
        {:error, :no_host}
      _ ->
        {:ok, url}
    end
  end

  def generate_short_code(url) do
    :crypto.hash(:md5, url)
    |> Base.encode64()
    |> binary_part(0, 8)
  end
end
