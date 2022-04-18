defmodule ServyHttpServerTest do
  use ExUnit.Case, async: true

  describe "http server" do
    spawn(Servy.HttpServer, :start, [3000])

    test "serves a static page" do
      response = Servy.HttpClient.get("/about.html")

      assert response.status_code == 200

      assert response.body ==
               "<html>\n  <body>\n    <h1>About</h1>\n    <p>A little about</p>\n  </body>\n</html>\n"
    end

    test "serves a dynamic response" do
      response = Servy.HttpClient.get("/coffee")

      assert response.status_code == 200

      assert response.body ==
               "<html>\n  <h1>All coffee orders</h1>\n\n  <ul>\n\n      <li>Cappuccino with Soy</li>\n\n      <li>Espresso with no</li>\n\n      <li>Flat White with Cow</li>\n\n      <li>Latte with Almond</li>\n\n      <li>Ling Black with Cow</li>\n\n  </ul>\n</html>\n"
    end
  end
end
