defmodule Servy.Routes do
  @moduledoc """
  Define routes to be used when matching against the method and path
  """
  defmacro __using__(_opts) do
    quote do
      def get("/coffee", _request) do
        %Servy.Request{
          response: %Servy.Response{status: 200, body: "Espresso, Latte, Cappuccino"}
        }
      end

      def get("/coffee/" <> id, _request) do
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

      def handle_file({:ok, content}, path, _request),
        do: %Servy.Request{response: %Servy.Response{status: 200, body: content}}

      def handle_file({:error, :enoent}, path, _request),
        do: %Servy.Request{
          response: %Servy.Response{status: 404, body: "#{path} not found"},
          path: path
        }

      def handle_file({:error, reason}, path, _request),
        do: %Servy.Request{response: %Servy.Response{status: 500, body: "Something went wrong"}}

      @doc """
      Create a new Coffee order
      """
      def post("/coffee", %Servy.Request{params: params}) do
        %Servy.Request{
          response: %Servy.Response{
            status: 201,
            body: "Made a coffee #{params["name"]} with #{params["milk"]} milk"
          }
        }
      end

      def post(path, _request) do
        %Servy.Request{
          response: %Servy.Response{status: 404, body: "#{path} not found"},
          path: path
        }
      end

      def delete(path, _request) do
        %Servy.Request{
          response: %Servy.Response{status: 404, body: "#{path} not found"},
          path: path
        }
      end
    end
  end
end
