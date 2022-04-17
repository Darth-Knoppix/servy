defmodule ServyModelsCoffeeTest do
  use ExUnit.Case
  doctest Servy.Models.Coffee

  describe "get_order/1" do
    test "returns nil if not found" do
      assert Servy.Models.Coffee.get_order(101) == nil
    end
  end
end
