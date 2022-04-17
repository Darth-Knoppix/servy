defmodule ServyHandlerTest do
  use ExUnit.Case
  doctest Servy.Handler

  defp make_get_request(path) do
    """
    GET #{path} HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
  end

  describe "handle/1" do
    test "coffee route" do
      expected_response = """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 236

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
      HTTP/1.1 404 Not Found
      Content-Type: text/html
      Content-Length: 16

      Coffee not found
      """

      assert Servy.Handler.handle(make_get_request("/coffee/101")) == expected_response
    end

    test "static html request" do
      expected_response = """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 79

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
      POST /coffee HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*
      Content-Type: application/x-www-form-urlencoded
      Content-Length: 21

      name=Piccolo&milk=Soy
      """

      expected_response = """
      HTTP/1.1 201 Created
      Content-Type: text/html
      Content-Length: 35

      Made a coffee Piccolo with Soy milk
      """

      assert Servy.Handler.handle(request) == expected_response
    end

    test "unknown route" do
      expected_response = """
      HTTP/1.1 404 Not Found
      Content-Type: text/html
      Content-Length: 22

      /not-a-route not found
      """

      assert Servy.Handler.handle(make_get_request("/not-a-route")) == expected_response
    end
  end
end
