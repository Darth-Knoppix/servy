defmodule Servy.Response do
  @moduledoc """
  A Response map which will be serialized by `Servy.Handler.format/1`
  """
  defstruct body: "", status: nil, headers: %{}

  @doc """
  Return the status code along with the associated message
  """
  @spec status_message(number()) :: String.t()
  def status_message(status) do
    "#{status} #{status_reason(status)}"
  end

  @spec status_reason(number) :: String.t()
  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      405 => "Method Not Allowed",
      500 => "Internal Server Error",
      501 => "Not Implemented"
    }[code]
  end
end
