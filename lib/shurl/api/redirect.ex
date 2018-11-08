defmodule Shurl.API.Redirect do
  use Maru.Router
  alias Shurl.{Link, Schema, Cache, Storage, Analyst, API}

  route_param :short_code do
    ## GET /:short_code
    get do
      short_code = params[:short_code]
      case Cache.read(short_code) || Storage.Link.get_link(%{short_code: short_code}) do
        nil ->
          conn
          |> put_status(404)
          |> json(%{status: "error", response: API.not_found_response()})
        {_, url} ->
          :ok = Analyst.process(conn)
          {:ok, link} = Link.collect_link(%{url: url, params: conn.query_params})

          conn
          |> redirect(link.url)
        %Schema.Link{is_expired: true} ->
          conn
          |> put_status(404)
          |> json(%{status: "error", response: API.expired_response()})
        %Schema.Link{id: link_id, url: url} ->
          :ok = Analyst.process(conn)
          Cache.write(short_code, {link_id, url})
          {:ok, link} = Link.collect_link(%{url: url, params: conn.query_params})

          conn
          |> redirect(link.url)
      end
    end
  end
end
