defmodule ServyPluginsTest do
  use ExUnit.Case
  doctest Servy.Plugins

  describe "track/1" do
    test "returns request unmutated" do
      Servy.Plugins.track(%Servy.Request{}) == %Servy.Request{}
    end
  end
end
