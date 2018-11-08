defmodule Shurl.API.Link do
  use Maru.Router
  alias Shurl.{Link, Schema, Cache, Storage, API}

  namespace :link do
    ## POST /link
    params do
      requires :url, type: String
    end

    post do
      case Link.collect_link(%{url: params[:url]}) do
        {:error, _} ->
          conn
          |> put_status(422)
          |> json(%{status: "error", response: API.invalid_url_response()})
        {:ok, link} ->
          unless Cache.read(link.short_code) do
            result =
              %Schema.Link{url: link.url, short_code: link.short_code}
              |> Schema.Link.changeset
              |> Storage.Link.upsert_link
            case result do
              {:ok, %Schema.Link{id: link_id}} ->
                Cache.write(link.short_code, {link_id, link.url})
              {:error, :rollback} ->
                nil
            end
          end

          conn
          |> json(%{status: "success", response: "/#{link.short_code}"})
      end
    end

    route_param :short_code do
      ## GET /link/:short_code
      get do
        short_code = params[:short_code]
        case Cache.read(short_code) || Storage.Link.get_link(%{short_code: short_code}) do
          nil ->
            conn
            |> put_status(404)
            |> json(%{status: "error", response: API.not_found_response()})
          {_, url} ->
            conn
            |> json(%{status: "success", response: url})
          %Schema.Link{is_expired: true} ->
            conn
            |> put_status(404)
            |> json(%{status: "error", response: API.expired_response()})
          %Schema.Link{id: link_id, url: url} ->
            Cache.write(short_code, {link_id, url})

            conn
            |> json(%{status: "success", response: url})
        end
      end
    end
  end
end
