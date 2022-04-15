defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
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

  def route(request) do
    cond do
      %{method: "GET"} ->
        get(request.path, request.headers)

      %{method: "POST"} ->
        post(request.path, request.headers)

      true ->
        %{response: %{status: 405, body: "only GET and POST are supported"}}
    end
  end

  def get("/coffee", _headers) do
    %{response: %{status: 200, body: "Espresso, Latte, Cappuccino"}}
  end

  def get(path, _headers) do
    %{response: %{status: 404, body: "#{path} not found"}}
  end

  def post("/coffee", _headers) do
    %{response: %{status: 501, body: ""}}
  end

  def post(path, _headers) do
    %{response: %{status: 404, body: "#{path} not found"}}
  end

  def format(%{:response => response}) do
    """
    HTTP/1.1 #{response[:status]} OK
    Content-Type: text/html
    Content-Length: #{byte_size(response[:body])}

    #{response[:body]}
    """
  end
end
