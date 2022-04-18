defmodule ServyHttpServerTest do
  use ExUnit.Case, async: true

  describe "http server" do
    spawn(Servy.HttpServer, :start, [3000])

    test "serves a static page" do
      request = """
      GET /about.html HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = Servy.HttpClient.send_request(request)

      assert response ==
               "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 79\r\n\r\n<html>\n  <body>\n    <h1>About</h1>\n    <p>A little about</p>\n  </body>\n</html>\n\n"
    end

    test "serves a dynamic response" do
      request = """
      GET /coffee HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = Servy.HttpClient.send_request(request)

      assert response ==
               "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 236\r\n\r\n<html>\n  <h1>All coffee orders</h1>\n\n  <ul>\n\n      <li>Cappuccino with Soy</li>\n\n      <li>Espresso with no</li>\n\n      <li>Flat White with Cow</li>\n\n      <li>Latte with Almond</li>\n\n      <li>Ling Black with Cow</li>\n\n  </ul>\n</html>\n\n"
    end
  end
end
