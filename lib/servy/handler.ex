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
        get(request.path, request.headers)

      %{method: "POST"} ->
        post(request.path, request.headers)

      %{method: "DELETE"} ->
        delete(request.path, request.headers)

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
      "HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 4\n\ntest\n"

      iex> Servy.Handler.format(%Servy.Request{response: %Servy.Response{status: 500, body: "Errør" }})
      "HTTP/1.1 500 Internal Server Error\nContent-Type: text/html\nContent-Length: 6\n\nErrør\n"


  """
  @spec format(%Request{}) :: String.t()
  def format(%Request{:response => response}) do
    """
    HTTP/1.1 #{response.status} #{status_reason(response.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(response.body)}

    #{response.body}
    """
  end

  @spec status_reason(number) :: String.t()
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
