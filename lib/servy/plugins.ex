defmodule Servy.Plugins do
  require Logger

  def log(request), do: IO.inspect(request)

  @doc ~S"""

  ## Examples

      iex> Servy.Plugins.track(%{response: %{status: 404}, path: "/"})
      %{path: "/", response: %{status: 404}}

      iex> Servy.Plugins.track(%{response: %{status: 200}, path: "/"})
      %{path: "/", response: %{status: 200}}
  """
  def track(%{response: %{status: 404}, path: path} = request) do
    Logger.debug("#{path} wasn't found!")
    request
  end

  def track(request), do: request
end

defmodule Servy.Plugins.Rerwites do
  defmacro __using__(_opts) do
    quote do
      def rewrite_path(%{path: "/drinks"} = request) do
        %{request | path: "/coffee"}
      end

      def rewrite_path(request), do: request
    end
  end
end
