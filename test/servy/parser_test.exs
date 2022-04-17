defmodule ServyParserTest do
  use ExUnit.Case, async: true
  doctest Servy.Parser

  describe "parse_headers/1" do
    test "parses headers into map" do
      headers = ["Content-Type: text/html"]

      expected = %{
        "Content-Type" => "text/html"
      }

      assert Servy.Parser.parse_headers(headers) == expected
    end
  end

  describe "parse_params/2" do
    test "parses application/x-www-form-urlencoded correctly" do
      expected = %{
        "a" => "1",
        "b" => "2"
      }

      assert Servy.Parser.parse_params("application/x-www-form-urlencoded", "a=1&b=2") == expected
    end
  end
end
