defmodule Servy.Controllers.Coffee do
  alias Servy.{Request, Response}
  alias Servy.Models.Coffee

  @doc """
  Show all coffee orders
  """
  @spec index(%Servy.Request{}) :: %Servy.Request{}
  def index(request) do
    items =
      Coffee.list_all()
      |> Enum.sort(fn x, y -> x.name <= y.name end)
      |> Enum.map(fn %{name: name, milk: milk} -> "<li>#{name} with #{milk}</li>" end)
      |> Enum.join()

    %Request{
      request
      | response: %Response{status: 200, body: "<ul>#{items}</ul>"}
    }
  end

  @doc """
  Show the coffee matching an ID
  """
  @spec show(%Servy.Request{}, map()) :: %Servy.Request{}
  def show(request, %{id: id}) do
    coffee = Coffee.get_order(id)

    case coffee do
      nil ->
        %Request{
          request
          | response: %Response{status: 404, body: "Coffee not found"}
        }

      _ ->
        %Request{
          request
          | response: %Response{status: 200, body: "Coffee: #{coffee.name}, Milk: #{coffee.milk}"}
        }
    end
  end

  @doc """
  Create a new Coffee order
  """
  @spec create(%Servy.Request{}, map()) :: %Servy.Request{}
  def create(request, %{"name" => name, "milk" => milk}) do
    %Request{
      request
      | response: %Response{
          status: 201,
          body: "Made a coffee #{name} with #{milk} milk"
        }
    }
  end
end
