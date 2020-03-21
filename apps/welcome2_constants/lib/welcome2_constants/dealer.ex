defmodule Welcome2Constants.Dealer do
  @me __MODULE__

  def start_link do
    Agent.start_link(&read_decks/0, name: @me)
  end

  def deck do
    Agent.get(@me, fn d -> d end)
  end

  defp read_decks do
    "../../assets/decks.json"
    |> Path.expand(__DIR__)
    |> File.read!()
  end
end
