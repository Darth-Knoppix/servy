defmodule Servy.Request do
  @moduledoc """
  A Request containing important proerties and the response
  """
  defstruct method: "", path: "", response: %Servy.Response{}, headers: []
end
