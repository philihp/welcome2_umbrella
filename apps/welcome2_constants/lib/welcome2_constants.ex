defmodule Welcome2Constants do
  alias Welcome2Constants.{Dealer, Planner}
  defdelegate deck, to: Dealer
  defdelegate plans, to: Planner
end
