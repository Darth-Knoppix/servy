defmodule Servy.Api.Order do
  @moduledoc """
  Creates orders in memory and keeps track of recent orders
  """

  @name :order_service

  require Logger

  def start do
    if Mix.env() != :test do
      Logger.info("Starting the order service")
    end

    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def listen_loop(state \\ []) do
    if Mix.env() != :test do
      Logger.info("Awaiting orders...")
    end

    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = handle_call(message, state)
        send(sender, {:response, response})
        listen_loop(new_state)

      {:cast, message} ->
        new_state = handle_cast(message, state)
        listen_loop(new_state)

      message ->
        if Mix.env() != :test do
          Logger.error("Unknown message: #{inspect(message)}")
        end

        listen_loop(state)
    end
  end

  def handle_call({:create_order, name, amount}, state) do
    if Mix.env() != :test do
      Logger.info("#{amount} x #{name} ordered")
    end

    recent = Enum.take(state, 2)
    new_state = [{name, amount} | recent]
    {"order-#{:rand.uniform(100)}", new_state}
  end

  def handle_call(:recent_orders, state) do
    {state, state}
  end

  def handle_cast(:clear_recent_orders, _state) do
    if Mix.env() != :test do
      Logger.info("Cleared recent orders")
    end

    []
  end

  def create_order(name, amount) do
    call(@name, {:create_order, name, amount})
  end

  def most_recent_orders() do
    call(@name, :recent_orders)
  end

  def clear_recent_orders() do
    cast(@name, :clear_recent_orders)
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end
end
