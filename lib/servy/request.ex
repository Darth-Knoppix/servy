defmodule Servy.Request do
  @moduledoc """
  A Request containing important proerties and the response
  """
  defstruct method: "",
            path: "",
            protocol: "",
            response: %Servy.Response{},
            headers: %{},
            params: %{}
end
