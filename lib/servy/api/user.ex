defmodule Servy.Api.User do
  @moduledoc """
  A mock user service that fetches data from another API using HTTPoison
  """

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
