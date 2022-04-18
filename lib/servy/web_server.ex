defmodule Servy.WebServer do
  use GenServer

  # Client Interface

  def start_link(_args) do
    IO.puts("Starting the webserver...")
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call(__MODULE__, :get_server)
  end

  # Server Callbacks

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HttpServer exited (#{inspect(reason)})")
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts("Starting the HTTP server...")
    port = Application.get_env(:servy, :port, 4000)
    spawn_link(Servy.HttpServer, :start, [port])
  end
end
