defmodule Servy.Api.Order do
  @moduledoc """
  Creates orders in memory and keeps track of recent orders
  """
  @name :order_service

  use GenServer

  require Logger

  defmodule State do
    defstruct cache_size: 3, orders: []
  end

  def start_link(_args) do
    if Mix.env() != :test do
      Logger.info("Starting the order service")
    end

    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def create_order(name, amount) do
    GenServer.call(@name, {:create_order, name, amount})
  end

  def most_recent_orders() do
    GenServer.call(@name, :recent_orders)
  end

  def clear_recent_orders() do
    GenServer.cast(@name, :clear_recent_orders)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
  end

  # Server callbacks

  @impl true
  def init(state) do
    # This could be populated from an external API
    orders = []
    {:ok, %State{state | orders: orders}}
  end

  @impl true
  def handle_call({:create_order, name, amount}, _from, state) do
    if Mix.env() != :test do
      Logger.info("#{amount} x #{name} ordered")
    end

    recent = Enum.take(state.orders, state.cache_size - 1)
    new_orders = [{name, amount} | recent]
    {:reply, "order-#{:rand.uniform(100)}", %State{state | orders: new_orders}}
  end

  @impl true
  def handle_call(:recent_orders, _from, state) do
    {:reply, state.orders, state}
  end

  @impl true
  def handle_cast(:clear_recent_orders, state) do
    if Mix.env() != :test do
      Logger.info("Cleared recent orders")
    end

    {:noreply, %State{state | orders: []}}
  end

  @impl true
  def handle_cast({:set_cache_size, size}, state) do
    if Mix.env() != :test do
      Logger.info("Set cache size to #{size}")
    end

    {:noreply, %State{state | cache_size: size}}
  end
end
