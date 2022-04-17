defmodule Servy.Handler do
  @moduledoc """
  Handle simple HTTP/1.1 requests
  """

  @pages_path Path.expand("../../public", __DIR__)

  alias Servy.{Request, Response}

  use Servy.Plugins.Rerwites
  use Servy.Routes

  @doc """
  Accept an HTTP request and return a response
  """

  @spec handle(String.t()) :: String.t()
  def handle(request) do
    request
    |> Servy.Parser.parse()
    |> rewrite_path
    |> route
    |> Servy.Plugins.track()
    |> format
  end

  @doc ~S"""

  Match on a route given the method and path

  ## Examples

      iex> Servy.Handler.route(%Servy.Request{ method: "PUT", path: "/", headers: [] })
      %Servy.Request{response: %Servy.Response{body: "only GET, POST & DELETE are supported", status: 405} }

      iex> Servy.Handler.route(%Servy.Request{ method: "POST", path: "/", headers: [] })
      %Servy.Request{response: %Servy.Response{body: "/ not found", status: 404}, path: "/" }

  """

  @spec route(%Request{}) :: %Request{}
  def route(request) do
    case request do
      %{method: "GET"} ->
        get(request.path, request)

      %{method: "POST"} ->
        post(request.path, request)

      %{method: "DELETE"} ->
        delete(request.path, request)

      _ ->
        %Request{
          response: %Response{status: 405, body: "only GET, POST & DELETE are supported"}
        }
    end
  end

  @doc ~S"""
  Format a map into an HTTP response

  ## Examples

      iex> Servy.Handler.format(%Servy.Request{response: %Servy.Response{status: 200, body: "test" }})
      "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 4\r\n\r\ntest\n"

      iex> Servy.Handler.format(%Servy.Request{response: %Servy.Response{status: 500, body: "Errør" }})
      "HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/html\r\nContent-Length: 6\r\n\r\nErrør\n"


  """
  @spec format(%Request{}) :: String.t()
  def format(%Request{:response => response}) do
    headers =
      response.headers
      |> Enum.map(fn {key, value} -> "#{key}: #{value}\r" end)
      |> Enum.sort()
      |> Enum.join("\n")

    """
    HTTP/1.1 #{Response.status_message(response.status)}\r
    #{headers}
    Content-Length: #{byte_size(response.body)}\r
    \r
    #{response.body}
    """
  end
end
