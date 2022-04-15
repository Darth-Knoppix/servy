defmodule ServyHandlerTest do
  use ExUnit.Case
  doctest Servy.Handler

  describe "handle/1" do
    test "coffee route" do
      request = """
      GET /coffee HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      expected_response = """
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 27

      Espresso, Latte, Cappuccino
      """

      assert Servy.Handler.handle(request) == expected_response
    end

    test "unknown route" do
      request = """
      GET /not-a-route HTTP/1.1
      Host: example.com
      User-Agent: ExampleBrowser/1.0
      Accept: */*

      """

      expected_response = """
      HTTP/1.1 404 Not Found
      Content-Type: text/html
      Content-Length: 22

      /not-a-route not found
      """

      assert Servy.Handler.handle(request) == expected_response
    end
  end
end
