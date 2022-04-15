defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse

    # |> route
    # |> format
  end

  def parse(request) do
    lines = String.split(request, "\n")
    [request_line | headers_and_body] = lines

    Map.merge(parse_request_line(request_line), parse_headers(headers_and_body))
  end

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

  def route() do
  end

  def format() do
  end
end

request = """
GET /somthing HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers
"""

response = Servy.Handler.handle(request)

IO.inspect(response)
