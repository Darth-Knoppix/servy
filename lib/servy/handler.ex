defmodule Servy.Handler do
  require Logger

  use Servy.Routes

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    |> track
    |> format
  end

  def log(request), do: IO.inspect(request)

  def parse(request) do
    lines = String.split(request, "\n")
    [request_line | headers_and_body] = lines

    Map.merge(parse_request_line(request_line), parse_headers(headers_and_body))
  end

  @doc ~S"""
  Parse a request line and extract the method, path and protocol

  ## Examples

    iex> Servy.Handler.parse_request_line("HTTP/1.1 200 OK")
    %{method: "HTTP/1.1", path: "200", protocol: "OK"}
  """
  def parse_request_line(request_line) do
    [method, path, protocol] = String.split(request_line, " ")
    %{method: method, path: path, protocol: protocol}
  end

  def parse_headers(headers_and_body) do
    {raw_headers, [_ | raw_body]} =
      Enum.split_with(headers_and_body, fn x -> String.length(x) != 0 end)

    headers =
      raw_headers
      |> Enum.map(&String.split(&1, ": "))
      |> Map.new(fn [k, v] -> {k, v} end)

    %{headers: headers, body: Enum.join(raw_body, "\n")}
  end

  @doc ~S"""

  Match on a route given the method and path

  ## Examples

    iex> Servy.Handler.route(%{ method: "PUT", path: "/", headers: [] })
    %{response: %{body: "only GET, POST & DELETE are supported", status: 405} }

    iex> Servy.Handler.route(%{ method: "POST", path: "/", headers: [] })
    %{response: %{body: "/ not found", status: 404}, path: "/" }

  """
  def route(request) do
    case request do
      %{method: "GET"} ->
        get(request.path, request.headers)

      %{method: "POST"} ->
        post(request.path, request.headers)

      %{method: "DELETE"} ->
        delete(request.path, request.headers)

      _ ->
        %{response: %{status: 405, body: "only GET, POST & DELETE are supported"}}
    end
  end

  def track(%{response: %{status: 404}, path: path} = request) do
    Logger.debug("#{path} wasn't found!")
    request
  end

  def track(request), do: request

  @doc ~S"""
  Format a map into an HTTP response

  ## Examples

    iex> Servy.Handler.format(%{response: %{status: 200, body: "test" }})
    "HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 4\n\ntest\n"

    iex> Servy.Handler.format(%{response: %{status: 500, body: "Errør" }})
    "HTTP/1.1 500 Internal Server Error\nContent-Type: text/html\nContent-Length: 6\n\nErrør\n"

  """

  def format(%{:response => response}) do
    """
    HTTP/1.1 #{response.status} #{status_reason(response.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(response[:body])}

    #{response[:body]}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      405 => "Method Not Allowed",
      500 => "Internal Server Error",
      501 => "Not Implemented"
    }[code]
  end
end
