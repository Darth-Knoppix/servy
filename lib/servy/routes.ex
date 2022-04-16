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

      @doc """
      Try load a static file or fallback to 404
      """
      def get(path, _headers) do
        result =
          Path.expand("../../public", __DIR__)
          |> Path.join(path)
          |> File.read()

        case result do
          {:ok, content} ->
            %{response: %{status: 200, body: content}}

          {:error, :enoent} ->
            %{response: %{status: 404, body: "#{path} not found"}, path: path}

          {:error, reason} ->
            %{status: 500, body: "Something went wrong"}
        end
      end

      def post("/coffee", _headers) do
        %{response: %{status: 501, body: ""}}
      end

      def post(path, _headers) do
        %{response: %{status: 404, body: "#{path} not found"}, path: path}
      end

      def delete(path, _headers) do
        %{response: %{status: 404, body: "#{path} not found"}, path: path}
      end
    end
  end
end
