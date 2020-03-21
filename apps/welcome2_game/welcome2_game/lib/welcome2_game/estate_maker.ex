defmodule Welcome2Game.EstateMaker do
  alias Welcome2Game.{Tableau, State}

  @houses_per_row %{
    a: 10,
    b: 11,
    c: 12
  }

  def a <|> b do
    Map.merge(a, b, fn _k, va, vb -> va + vb end)
  end

  def update(state, options \\ [])

  def update(state = %State{}, options) do
    %State{
      state
      | player: update(state.player, options)
    }
  end

  def update(player = %Tableau{}, options) do
    estates =
      estates_from_player(player, :a, options)
      <|> estates_from_player(player, :b, options)
      <|> estates_from_player(player, :c, options)

    %Tableau{
      player
      | built_estates1: Map.get(estates, 1, 0),
        built_estates2: Map.get(estates, 2, 0),
        built_estates3: Map.get(estates, 3, 0),
        built_estates4: Map.get(estates, 4, 0),
        built_estates5: Map.get(estates, 5, 0),
        built_estates6: Map.get(estates, 6, 0)
    }
  end

  def estates_from_player(player = %Tableau{}, which, options \\ []) do
    houses =
      player |> houses_from_player(which, @houses_per_row[which], options) |> Enum.reverse()

    fences = player |> fences_from_player(which, @houses_per_row[which]) |> Enum.reverse()

    estates_from_row(houses, fences)
    |> Enum.map(&estate_sizer/1)
    |> Enum.reduce(%{}, fn estatesize, accum ->
      (estatesize != 0 &&
         Map.update(accum, estatesize, 1, &(&1 + 1))) ||
        accum
    end)
  end

  def estate_sizer(0) do
    0
  end

  def estate_sizer(power_of_ten) do
    length(Integer.digits(power_of_ten))
  end

  def estates_from_row([true], [true]) do
    [1]
  end

  def estates_from_row([false], [true]) do
    [0]
  end

  def estates_from_row([_], [false]) do
    []
  end

  def estates_from_row([true | houses], [true | fences]) do
    [1 | estates_from_row(houses, fences)]
  end

  def estates_from_row([false | houses], [true | fences]) do
    [0 | estates_from_row(houses, fences)]
  end

  def estates_from_row([true | houses], [false | fences]) do
    [following | trailing] = estates_from_row(houses, fences)
    [10 * following | trailing]
  end

  def estates_from_row([false | houses], [false | fences]) do
    [following | trailing] = estates_from_row(houses, fences)
    [0 * following | trailing]
  end

  def houses_from_player(player, which, curr, options \\ [])

  def houses_from_player(_player, _which, 0, _options) do
    []
  end

  def houses_from_player(player, which, curr, options) when curr >= 1 do
    exclude_used = Keyword.get(options, :exclude_used, true)

    [
      Map.get(player, :"row#{which}#{curr}number", :invalid) !== nil &&
        exclude_used && Map.get(player, :"row#{which}#{curr}plan", :invalid) === false
      | houses_from_player(player, which, curr - 1, options)
    ]
  end

  def fences_from_player(_player = %Tableau{}, _which, 0) do
    []
  end

  def fences_from_player(player = %Tableau{}, which, curr) when curr >= 0 do
    [
      Map.get(player, :"fence#{which}#{curr}", true)
      | fences_from_player(player, which, curr - 1)
    ]
  end
end
