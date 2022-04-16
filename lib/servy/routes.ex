defmodule Servy.Routes do
  @moduledoc """
  Define routes to be used when matching against the method and path
  """
  defmacro __using__(_opts) do
    quote do
      def get("/coffee", _headers) do
        %Servy.Request{
          response: %Servy.Response{status: 200, body: "Espresso, Latte, Cappuccino"}
        }
      end

      def get("/coffee/" <> id, _headers) do
        %Servy.Request{response: %Servy.Response{status: 200, body: "Coffee: #{id}"}}
      end

      @doc """
      Try load a static file or fallback to 404
      """
      def get(path, headers) do
        result =
          @pages_path
          |> Path.join(path)
          |> File.read()
          |> handle_file(path, headers)
      end

      def handle_file({:ok, content}, path, _headers),
        do: %Servy.Request{response: %Servy.Response{status: 200, body: content}}

      def handle_file({:error, :enoent}, path, _headers),
        do: %Servy.Request{
          response: %Servy.Response{status: 404, body: "#{path} not found"},
          path: path
        }

      def handle_file({:error, reason}, path, _headers),
        do: %Servy.Request{response: %Servy.Response{status: 500, body: "Something went wrong"}}

      def post("/coffee", _headers) do
        %Servy.Request{response: %Servy.Response{status: 501, body: ""}}
      end

      def post(path, _headers) do
        %Servy.Request{
          response: %Servy.Response{status: 404, body: "#{path} not found"},
          path: path
        }
      end

      def delete(path, _headers) do
        %Servy.Request{
          response: %Servy.Response{status: 404, body: "#{path} not found"},
          path: path
        }
      end
    end
  end
end
