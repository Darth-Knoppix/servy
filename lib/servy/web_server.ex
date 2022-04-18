defmodule Servy.WebServer do
  use GenServer

  # Client Interface

  def start_link(_args) do
    IO.puts("Starting the webserver...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Server Callbacks

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HttpServer exited (#{inspect(reason)})")
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts("Starting the HTTP server...")
    port = Application.get_env(:servy, :port, 4000)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
