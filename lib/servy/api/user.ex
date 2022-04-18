defmodule Servy.Api.User do
  @base_url "https://jsonplaceholder.typicode.com/users/"

  def list_all() do
    {:ok, response} = HTTPoison.get(@base_url)
    Jason.decode!(response.body)
  end

  def get(id) do
    {:ok, response} = HTTPoison.get("#{@base_url}#{id}/")
    Jason.decode!(response.body)
  end
end
