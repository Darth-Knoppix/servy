defmodule Servy.Api.InventoryCache do
  @moduledoc """
  Get the inventory and cache the values, refresh every 5 minutes
  """

  @name :inventory_cache_service
  @refresh_interval :timer.minutes(5)

  require Logger

  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def get_inventory do
    GenServer.call(@name, :get_inventory)
  end

  # Server callbacks

  def init(_state) do
    initial_state = fetch_inventory()
    schedule_cache_refresh()
    {:ok, initial_state}
  end

  def handle_info(:refresh, _state) do
    if Mix.env() != :test do
      Logger.info("Refreshing the cache...")
    end

    new_state = fetch_inventory()

    if Mix.env() != :test do
      Logger.info("New data: #{inspect(new_state)}")
    end

    schedule_cache_refresh()
    {:noreply, new_state}
  end

  defp schedule_cache_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  @doc """
  Some async task that gets inventory levels
  """
  defp fetch_inventory do
    if Mix.env() != :test do
      Logger.info("Getting inventory levels...")
    end

    :timer.sleep(200)

    %{
      "Dark Roast" => :rand.uniform(100),
      "Medium Roast" => :rand.uniform(100),
      "Soy Milk" => :rand.uniform(10),
      "Almond Milk" => :rand.uniform(10),
      "Cow's Milk" => :rand.uniform(30)
    }
  end
end
