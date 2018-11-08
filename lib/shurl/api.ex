defmodule Shurl.API do
  require Logger
  use Maru.Router
  use Plug.ErrorHandler
  alias Shurl.API

  ### Routing

  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Poison,
    parsers: [:urlencoded, :json, :multipart]

  mount API.Link
  mount API.Analytics
  mount API.Redirect

  ### Error processing

  rescue_from Plug.Parsers.ParseError, as: e do
    process_parse_error(conn, e)
  end

  rescue_from Maru.Exceptions.NotFound, as: e do
    process_not_allowed(conn, e)
  end

  rescue_from Maru.Exceptions.MethodNotAllowed, as: e do
    process_not_allowed(conn, e)
  end

  rescue_from Maru.Exceptions.InvalidFormat, as: e do
    process_invalid(conn, e)
  end

  rescue_from Maru.Exceptions.Validation, as: e do
    process_invalid(conn, e)
  end

  rescue_from :all, as: e do
    process_all(conn, e)
  end

  def process_parse_error(conn, e) do
    message = "Invalid syntax of passed params"
    Logger.debug "#{message}: #{inspect e}"

    conn
    |> put_status(400)
    |> json(%{status: "error", response: message})
  end

  def process_not_allowed(conn, e) do
    path =
      [Map.get(e, :request_path) || Map.get(e, :path_info)]
      |> List.flatten
      |> Enum.join("/")
      |> String.trim("/")
    message = "Method #{e.method} not allowed for request path `/#{path}`"
    Logger.debug message

    conn
    |> put_status(405)
    |> json(%{status: "error", response: message})
  end

  def process_invalid(conn, e) do
    message = errors_message(e)
    Logger.debug message

    conn
    |> put_status(422)
    |> json(%{status: "error", response: message})
  end

  def process_all(conn, e) do
    Logger.error "Error: #{inspect e}\n#{inspect Exception.message(e)}"
    Logger.error "#{inspect System.stacktrace}"

    conn
    |> put_status(500)
    |> json(%{status: "error", response: "Unknown error"})
  end

  ### Response messages

  def errors_message(%Maru.Exceptions.InvalidFormat{} = e),
    do: "Invalid params: param=`#{e.param}`, reason=`#{e.reason}`, value=`#{inspect e.value}`"

  def invalid_url_response(), do: "Invalid URL"
  def not_found_response(),   do: "Short URL not found"
  def expired_response(),     do: "Short URL is expired"
end
