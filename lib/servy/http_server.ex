defmodule Servy.HttpServer do
  @doc """
  Starts the server on the given `port` of localhost.
  """
  def start(port) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} =
      :gen_tcp.listen(3000, [:binary, packet: :raw, active: false, reuseaddr: true])

    accept_loop(listen_socket)
  end

  @doc """
  Accepts client connections on the `listen_socket`.
  """
  def accept_loop(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    serve(client_socket)

    if Mix.env() != :test do
      accept_loop(listen_socket)
    end
  end

  @doc """
  Receives the request on the `client_socket` and
  sends a response back over the same socket.
  """
  def serve(client_socket) do
    client_socket
    |> read_request
    |> generate_response
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`.
  """
  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    request
  end

  @doc """
  Returns a generic HTTP response.
  """
  def generate_response(request), do: Servy.Handler.handle(request)

  @doc """
  Sends the `response` over the `client_socket`.
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)
    :gen_tcp.close(client_socket)
  end
end
