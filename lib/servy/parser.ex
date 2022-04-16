defmodule Servy.Parser do
  alias Servy.Request

  @moduledoc """
  Parse an HTTP request to pull out important parts like method,
  protocol, path, headers and body
  """
  @spec parse(String.t()) :: map()
  def parse(request) do
    [top | [body]] = String.split(request, "\n\n")
    [request_line | headers] = String.split(top, "\n")

    parsed_request = parse_request_line(request_line)

    %Request{parsed_request | headers: parse_headers(headers), params: parse_params(body)}
  end

  @doc ~S"""
  Parse a request line and extract the method, path and protocol

  ## Examples

      iex> Servy.Handler.parse_request_line("HTTP/1.1 200 OK")
      %{method: "HTTP/1.1", path: "200", protocol: "OK"}
  """
  @spec parse_request_line(String.t()) :: map()
  def parse_request_line(request_line) do
    [method, path, protocol] = String.split(request_line, " ")
    %Request{method: method, path: path, protocol: protocol}
  end

  def parse_params(""), do: ""

  def parse_params(params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

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
