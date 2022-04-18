defmodule Servy.Api.Order do
  @moduledoc """
  Creates orders in memory and keeps track of recent orders
  """

  require Logger

  def start do
    if Mix.env() != :test do
      Logger.info("Starting the order service")
    end

    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, :order_service)
  end

  def listen_loop(state \\ []) do
    if Mix.env() != :test do
      Logger.info("Awaiting orders...")
    end

    receive do
      {sender, :create_order, name, amount} ->
        if Mix.env() != :test do
          Logger.info("#{amount} x #{name} ordered")
        end

        recent = Enum.take(state, 2)
        new_state = [{name, amount} | recent]
        id = "order-#{:rand.uniform(100)}"
        send(sender, {:response, id})
        listen_loop(new_state)

      {sender, :recent_orders} ->
        send(sender, {:response, state})
        listen_loop(state)

      {sender, :clear_recent_orders} ->
        if Mix.env() != :test do
          Logger.info("Cleared recent orders")
        end

        send(sender, {:response, []})
        listen_loop([])
    end
  end

  def create_order(name, amount) do
    send(:order_service, {self(), :create_order, name, amount})

    receive do
      {:response, status} -> status
    end
  end

  def most_recent_orders() do
    send(:order_service, {self(), :recent_orders})

    receive do
      {:response, orders} -> orders
    end
  end

  def clear_recent_orders() do
    send(:order_service, {self(), :clear_recent_orders})

    receive do
      {:response, orders} -> orders
    end
  end
end