defmodule ServyApiOrderTerst do
  use ExUnit.Case
  alias Servy.Api.Order

  describe "order service" do
    Order.start()

    setup do
      Order.clear_recent_orders()
    end

    test "initial state is empty" do
      assert Order.most_recent_orders() == []
    end

    test "max of three recent orders" do
      Order.create_order("Latte", 1)
      Order.create_order("Latte", 2)
      Order.create_order("Latte", 3)
      Order.create_order("Latte", 4)

      assert Order.most_recent_orders() == [{"Latte", 4}, {"Latte", 3}, {"Latte", 2}]
    end

    test "clears correctly" do
      Order.create_order("Latte", 1)

      assert Order.most_recent_orders() == [{"Latte", 1}]

      Order.clear_recent_orders()

      assert Order.most_recent_orders() == []
    end
  end
end
