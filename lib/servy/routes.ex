defmodule Servy.Routes do
  @moduledoc """
  Define routes to be used when matching against the method and path
  """
  defmacro __using__(_opts) do
    quote do
      @spec get(String.t(), %Servy.Request{}) :: %Servy.Request{}
      def get("/coffee", request) do
        Servy.Controllers.Coffee.index(request)
      end

      def get("/coffee/" <> id, request) do
        params = Map.put(request.params, :id, id)
        Servy.Controllers.Coffee.show(request, params)
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

      def post("/coffee", %Servy.Request{params: params} = request) do
        Servy.Controllers.Coffee.create(request, params)
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
