defmodule Servy.Response do
  @moduledoc """
  A Response map which will be serialized by `Servy.Handler.format/1`
  """
  defstruct body: "", status: nil, headers: []
end
