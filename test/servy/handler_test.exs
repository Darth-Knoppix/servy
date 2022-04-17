defmodule ServyHandlerTest do
  use ExUnit.Case
  doctest Servy.Handler

  defp make_get_request(path) do
    """
    GET #{path} HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
  end

  describe "handle/1" do
    test "coffee route" do
      expected_response = """
      HTTP/1.1 200 OK\r
      Content-Type: text/html\r
      Content-Length: 236\r
      \r
      <html>
        <h1>All coffee orders</h1>

        <ul>

            <li>Cappuccino with Soy</li>

            <li>Espresso with no</li>

            <li>Flat White with Cow</li>

            <li>Latte with Almond</li>

            <li>Ling Black with Cow</li>

        </ul>
      </html>

      """

      assert Servy.Handler.handle(make_get_request("/coffee")) == expected_response
    end

    test "coffee with an invalid id" do
      expected_response = """
      HTTP/1.1 404 Not Found\r
      Content-Type: text/html\r
      Content-Length: 16\r
      \r
      Coffee not found
      """

      assert Servy.Handler.handle(make_get_request("/coffee/101")) == expected_response
    end

    test "static html request" do
      expected_response = """
      HTTP/1.1 200 OK\r
      Content-Type: text/html\r
      Content-Length: 79\r
      \r
      <html>
        <body>
          <h1>About</h1>
          <p>A little about</p>
        </body>
      </html>

      """

      assert Servy.Handler.handle(make_get_request("/about.html")) == expected_response
    end

    test "post /coffee request" do
      request = """
      POST /coffee HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      Content-Type: application/x-www-form-urlencoded\r
      Content-Length: 21\r
      \r
      name=Piccolo&milk=Soy
      """

      expected_response = """
      HTTP/1.1 201 Created\r
      Content-Type: text/html\r
      Content-Length: 35\r
      \r
      Made a coffee Piccolo with Soy milk
      """

      assert Servy.Handler.handle(request) == expected_response
    end

    test "unknown route" do
      expected_response = """
      HTTP/1.1 404 Not Found\r
      Content-Type: text/html\r
      Content-Length: 22\r
      \r
      /not-a-route not found
      """

      assert Servy.Handler.handle(make_get_request("/not-a-route")) == expected_response
    end
  end
end
