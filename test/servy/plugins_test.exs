defmodule ServyPluginsTest do
  use ExUnit.Case, async: true
  doctest Servy.Plugins

  describe "track/1" do
    test "returns request unmutated" do
      assert Servy.Plugins.track(%Servy.Request{}) == %Servy.Request{}
    end
  end
end
