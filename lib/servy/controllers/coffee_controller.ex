defmodule Servy.Controllers.Coffee do
  alias Servy.{Request, Response}

  @doc """
  Show all coffee orders
  """
  @spec index(%Servy.Request{}) :: %Servy.Request{}
  def index(request) do
    %Request{
      request
      | response: %Response{status: 200, body: "Espresso, Latte, Cappuccino"}
    }
  end

  @doc """
  Show the coffee matching an ID
  """
  @spec show(%Servy.Request{}, map()) :: %Servy.Request{}
  def show(request, %{id: id}) do
    %Request{
      request
      | response: %Response{status: 200, body: "Coffee: #{id}"}
    }
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
