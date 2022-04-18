defmodule Servy.HttpClient do
  @spec get(String.t()) :: %HTTPoison.Response{}
  def get(path) do
    {:ok, response} = HTTPoison.get("http://localhost:3000#{path}")
    response
  end
end
