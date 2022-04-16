defmodule Servy.Routes do
  defmacro __using__(_opts) do
    quote do
      def rewrite_path(%{path: "/drinks"} = request) do
        %{request | path: "/coffee"}
      end

      def rewrite_path(request), do: request

      def get("/coffee", _headers) do
        %{response: %{status: 200, body: "Espresso, Latte, Cappuccino"}}
      end

      def get("/coffee/" <> id, _headers) do
        %{response: %{status: 200, body: "Coffee: #{id}"}}
      end

      def get(path, _headers) do
        %{response: %{status: 404, body: "#{path} not found"}, path: path}
      end

      def post("/coffee", _headers) do
        %{response: %{status: 501, body: ""}}
      end

      def post(path, _headers) do
        %{response: %{status: 404, body: "#{path} not found"}, path: path}
      end
    end
  end
end
