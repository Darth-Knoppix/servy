defmodule Servy.Models.Coffee do
  defstruct id: nil, milk: "Cow", name: "", complete: false

  @doc """
  List all of the Coffee orders
  """
  @spec list_all() :: list(%Servy.Models.Coffee{})
  def list_all() do
    [
      %Servy.Models.Coffee{id: 1, name: "Espresso", milk: "no"},
      %Servy.Models.Coffee{id: 2, name: "Cappuccino", milk: "Soy"},
      %Servy.Models.Coffee{id: 3, name: "Latte", milk: "Almond"},
      %Servy.Models.Coffee{id: 4, name: "Flat White"},
      %Servy.Models.Coffee{id: 5, name: "Ling Black", complete: true}
    ]
  end

  @doc """
  Get a specific order

  ## Examples

      iex> Servy.Models.Coffee.get_order(1)
      %Servy.Models.Coffee{id: 1, name: "Espresso", milk: "no"}

  """
  @spec get_order(integer()) :: %Servy.Models.Coffee{}
  def get_order(id) do
    Enum.find(list_all(), fn x -> x.id == id end)
  end
end
