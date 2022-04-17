defmodule ServyControllersCoffeeTest do
  use ExUnit.Case
  doctest Servy.Controllers.Coffee

  describe "index/1" do
    test "returns a valid result" do
      response = %Servy.Request{
        response: %Servy.Response{body: "Espresso, Latte, Cappuccino", status: 200}
      }

      assert Servy.Controllers.Coffee.index(%Servy.Request{}) == response
    end
  end
end
