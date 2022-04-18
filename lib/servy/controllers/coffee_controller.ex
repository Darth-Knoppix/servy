defmodule Servy.Controllers.Coffee do
  alias Servy.{Request, Response}
  alias Servy.Models.Coffee

  @templates_path Path.expand("../../../templates/coffee", __DIR__)

  defp render(request, template, bindings \\ []) do
    body =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings, trim: true)

    %Request{
      request
      | response: %Response{status: 200, body: body}
    }
  end

  @doc """
  Show all coffee orders
  """
  @spec index(%Servy.Request{}) :: %Servy.Request{}
  def index(%Request{headers: %{"Content-Type": "application/json"}} = request) do
    orders =
      Coffee.list_all()
      |> Enum.sort(fn x, y -> x.name <= y.name end)

    body = Jason.encode!(orders)

    %Request{
      request
      | response: %Response{body: body, headers: %{"Content-Type": "application/json"}}
    }
  end

  def index(request) do
    orders =
      Coffee.list_all()
      |> Enum.sort(fn x, y -> x.name <= y.name end)

    render(request, "index.html.eex", orders: orders)
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
        render(request, "show.html.eex", coffee: coffee)
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

  def prepare() do
    :timer.sleep(1_000)

    {:ok}
  end
end
