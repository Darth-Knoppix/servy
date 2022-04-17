defmodule ServyControllersCoffeeTest do
  use ExUnit.Case
  doctest Servy.Controllers.Coffee

  describe "index/1" do
    test "returns a valid result" do
      response = %Servy.Request{
        response: %Servy.Response{
          body:
            "<ul><li>Cappuccino with Soy</li><li>Espresso with no</li><li>Flat White with Cow</li><li>Latte with Almond</li><li>Ling Black with Cow</li></ul>",
          status: 200
        }
      }

      assert Servy.Controllers.Coffee.index(%Servy.Request{}) == response
    end
  end
end
