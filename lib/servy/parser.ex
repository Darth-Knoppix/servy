defmodule Servy.Parser do
  alias Servy.Request

  @moduledoc """
  Parse an HTTP request to pull out important parts like method,
  protocol, path, headers and body
  """
  @spec parse(String.t()) :: map()
  def parse(request) do
    [top | [body]] = String.split(request, "\r\n\r\n")
    [request_line | headers] = String.split(top, "\r\n")

    parsed_request = parse_request_line(request_line)
    headers = parse_headers(headers)
    params = parse_params(headers["Content-Type"], body)

    %Request{
      parsed_request
      | headers: headers,
        params: params
    }
  end

  @doc ~S"""
  Parse a request line and extract the method, path and protocol

  ## Examples

      iex> Servy.Parser.parse_request_line("HTTP/1.1 200 OK")
      %Servy.Request{method: "HTTP/1.1", path: "200", protocol: "OK"}
  """
  @spec parse_request_line(String.t()) :: map()
  def parse_request_line(request_line) do
    [method, path, protocol] = String.split(request_line, " ")
    %Request{method: method, path: path, protocol: protocol}
  end

  @spec parse_params(String.t(), String.t()) :: map()
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}

  @doc ~S"""
  Parse header list into map
  """
  @spec parse_headers(list(String.t())) :: map()
  def parse_headers(headers) do
    headers
    |> Enum.map(&String.split(&1, ": "))
    |> Map.new(fn [k, v] -> {k, v} end)
  end
end
