defmodule Welcome2Game.Plan do
  # @derive [Poison.Encoder]
  defstruct [:needs, :points1, :points2]

  def clean_needs(plan = %__MODULE__{needs: needs}) do
    %__MODULE__{
      plan
      | needs:
          for {k, v} <- needs, into: %{} do
            {n, _} = Integer.parse(k)
            {n, v}
          end
    }
  end
end
