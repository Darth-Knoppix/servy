defmodule ServyControllersCoffeeTest do
  use ExUnit.Case, async: true
  doctest Servy.Controllers.Coffee

  alias Servy.{Request, Response}

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end

  describe "index/1" do
    test "returns a valid result" do
      body =
        remove_whitespace("""
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
        """)

      expected_response = %Request{
        response: %Response{
          body: body,
          status: 200
        }
      }

      result = Servy.Controllers.Coffee.index(%Request{})

      result = %{
        result
        | response: %{result.response | body: remove_whitespace(result.response.body)}
      }

      assert result == expected_response
    end

    test "returns json correctly" do
      body =
        "[{\"complete\":false,\"id\":2,\"milk\":\"Soy\",\"name\":\"Cappuccino\"},{\"complete\":false,\"id\":1,\"milk\":\"no\",\"name\":\"Espresso\"},{\"complete\":false,\"id\":4,\"milk\":\"Cow\",\"name\":\"Flat White\"},{\"complete\":false,\"id\":3,\"milk\":\"Almond\",\"name\":\"Latte\"},{\"complete\":true,\"id\":5,\"milk\":\"Cow\",\"name\":\"Ling Black\"}]"

      result =
        Servy.Controllers.Coffee.index(%Request{headers: %{"Content-Type": "application/json"}})

      assert result.response.body == body
    end
  end

  describe "show/2" do
    test "returns a valid result" do
      response = %Request{
        response: %Response{
          body: "<h1>Espresso</h1>\n<p>with no milk</p>\n",
          status: 200
        }
      }

      assert Servy.Controllers.Coffee.show(%Request{}, %{id: "1"}) == response
    end
  end
end
