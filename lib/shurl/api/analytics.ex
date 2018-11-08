defmodule Shurl.API.Analytics do
  use Maru.Router
  alias Shurl.{Schema, Cache, Storage, API}

  namespace :analytics do
    route_param :short_code do
      ## GET /analytics/:short_code
      get do
        short_code = params[:short_code]
        case Cache.read(short_code) || Storage.Link.get_link(%{short_code: short_code}) do
          nil ->
            conn
            |> put_status(404)
            |> json(%{status: "error", response: API.not_found_response()})
          {link_id, _} ->
            report = Storage.Click.get_clicks_report(%{link_id: link_id})
            {total_clicks, statistics} = total_clicks_and_statistics(report)

            conn
            |> json(%{status: "success", response: %{total: total_clicks, statistics: statistics}})
          %Schema.Link{is_expired: true} ->
            conn
            |> put_status(404)
            |> json(%{status: "error", response: API.expired_response()})
          %Schema.Link{id: link_id, url: url} ->
            Cache.write(short_code, {link_id, url})
            report = Storage.Click.get_clicks_report(%{link_id: link_id})
            {total_clicks, statistics} = total_clicks_and_statistics(report)

            conn
            |> json(%{status: "success", response: %{total: total_clicks, statistics: statistics}})
        end
      end
    end
  end

  defp total_clicks_and_statistics(report) do
    Enum.reduce(report, {0, %{}}, fn {heds, num}, {total, acc} ->
      {total + num, Map.put(acc, heds, num)}
    end)
  end
end
