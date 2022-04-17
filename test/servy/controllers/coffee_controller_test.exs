defmodule ServyControllersCoffeeTest do
  use ExUnit.Case
  doctest Servy.Controllers.Coffee

  describe "index/1" do
    test "returns a valid result" do
      body = """
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

      response = %Servy.Request{
        response: %Servy.Response{
          body: body,
          status: 200
        }
      }

      assert Servy.Controllers.Coffee.index(%Servy.Request{}) == response
    end
  end

  describe "show/2" do
    test "returns a valid result" do
      response = %Servy.Request{
        response: %Servy.Response{
          body: "<h1>Espresso</h1>\n<p>with no milk</p>\n",
          status: 200
        }
      }

      assert Servy.Controllers.Coffee.show(%Servy.Request{}, %{id: "1"}) == response
    end
  end
end
