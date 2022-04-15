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
      Content-Length: 27

      Espresso, Latte, Cappuccino
      """

      assert Servy.Handler.handle(make_get_request("/coffee")) == expected_response
    end

    test "coffee with id" do
      expected_response = """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 11

      Coffee: 101
      """

      assert Servy.Handler.handle(make_get_request("/coffee/101")) == expected_response
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
