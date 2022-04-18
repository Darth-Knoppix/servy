defmodule Servy.Api.Order do
  @moduledoc """
  Creates orders in memory and keeps track of recent orders
  """

  @behaviour GenServer

  use GenServer

  @name :order_service

  require Logger

  def start do
    if Mix.env() != :test do
      Logger.info("Starting the order service")
    end

    GenServer.start(__MODULE__, [], name: @name)
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

  def handle_call({:create_order, name, amount}, _from, state) do
    if Mix.env() != :test do
      Logger.info("#{amount} x #{name} ordered")
    end

    recent = Enum.take(state, 2)
    new_state = [{name, amount} | recent]
    {:reply, "order-#{:rand.uniform(100)}", new_state}
  end

  def handle_call(:recent_orders, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:clear_recent_orders, _state) do
    if Mix.env() != :test do
      Logger.info("Cleared recent orders")
    end

    {:noreply, []}
  end
end
