defmodule Servy do
  use Application

  @moduledoc """
  Documentation for `Servy`.
  """

  def start(_type, _args) do
    Servy.TopLevelSupervisor.start_link()
  end
end

defmodule Servy.TopLevelSupervisor do
  use Supervisor

  def start_link() do
    IO.puts("Starting Servy")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.Api.Order,
      Servy.Api.InventoryCache,
      Servy.WebServer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
