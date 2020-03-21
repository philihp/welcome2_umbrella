defmodule Welcome2Constants.Planner do
  @me __MODULE__

  def start_link do
    Agent.start_link(&read_plans/0, name: @me)
  end

  def plans do
    Agent.get(@me, fn d -> d end)
  end

  defp read_plans do
    for n <- 1..3 do
      "../../assets/plan#{n}.json"
      |> Path.expand(__DIR__)
      |> File.read!()
    end
  end
end
