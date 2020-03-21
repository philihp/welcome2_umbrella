defmodule Welcome2Game.MoveFinder do
  alias Welcome2Game.Card

  @per_row [a: 10, b: 11, c: 12]

  @buildable [
    a: 1,
    a: 2,
    a: 3,
    a: 4,
    a: 5,
    a: 6,
    a: 7,
    a: 8,
    a: 9,
    a: 10,
    b: 1,
    b: 2,
    b: 3,
    b: 4,
    b: 5,
    b: 6,
    b: 7,
    b: 8,
    b: 9,
    b: 10,
    b: 11,
    c: 1,
    c: 2,
    c: 3,
    c: 4,
    c: 5,
    c: 6,
    c: 7,
    c: 8,
    c: 9,
    c: 10,
    c: 11,
    c: 12
  ]

  @fences [
    a: 1,
    a: 2,
    a: 3,
    a: 4,
    a: 5,
    a: 6,
    a: 7,
    a: 8,
    a: 9,
    b: 1,
    b: 2,
    b: 3,
    b: 4,
    b: 5,
    b: 6,
    b: 7,
    b: 8,
    b: 9,
    b: 10,
    c: 1,
    c: 2,
    c: 3,
    c: 4,
    c: 5,
    c: 6,
    c: 7,
    c: 8,
    c: 9,
    c: 10,
    c: 11
  ]

  @estates %{
    1 => %{1 => 3},
    2 => %{2 => 3, 3 => 4},
    3 => %{3 => 4, 4 => 5, 5 => 6},
    4 => %{4 => 5, 5 => 6, 6 => 7, 7 => 8},
    5 => %{5 => 6, 6 => 7, 7 => 8, 8 => 10},
    6 => %{6 => 7, 7 => 8, 8 => 10, 10 => 12}
  }

  @landscaper %{
    :a => %{0 => 2, 2 => 4, 4 => 10},
    :b => %{0 => 2, 2 => 4, 4 => 6, 6 => 14},
    :c => %{0 => 2, 2 => 4, 4 => 6, 6 => 8, 8 => 18}
  }

  # TODO gross refactor
  def next_estate(size, current) do
    @estates[size][current]
  end

  def next_park(row, current) do
    @landscaper[row][current]
  end

  def moves(%{state: :setup}) do
    [:start]
  end

  def moves(state = %{state: :playing, permit: nil, player: player}) do
    # gross
    permits = %{
      1 => state.shown1,
      2 => state.shown2,
      3 => state.shown3
    }

    refusable(
      for permit_num <- 1..3, valid_permit?(player, permits[permit_num]) do
        {:permit, permit_num}
      end
    )
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "temp-agency", face: number},
        built: nil,
        effect: nil,
        player: player,
        checkpoint: checkpoint
      }) do
    rollback(checkpoint) ++
      for {row, index} <- @buildable,
          offset <- [-2, -1, 0, 1, 2],
          valid_build?(player, row, index, number + offset) do
        {:temp, row, index, offset}
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{face: number},
        built: nil,
        player: player,
        checkpoint: checkpoint
      }) do
    rollback(checkpoint) ++
      for {row, index} <- @buildable, valid_build?(player, row, index, number) do
        {:build, row, index}
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "pool-manufacturer"},
        built: {row, index},
        effect: nil,
        player: player,
        checkpoint: checkpoint
      }) do
    [:commit] ++
      rollback(checkpoint) ++
      cond do
        valid_pool?(player, row, index) ->
          [:pool]

        true ->
          []
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "bis"},
        built: {_, _},
        effect: nil,
        player: player,
        checkpoint: checkpoint
      }) do
    [:commit] ++
      rollback(checkpoint) ++
      for {row, index} <- @buildable,
          offset <- [-1, 1],
          valid_bis?(player, row, index, offset) do
        {:bis, row, index, offset}
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "real-estate-agent"},
        built: {_, _},
        effect: nil,
        player: player,
        checkpoint: checkpoint
      }) do
    [:commit] ++
      rollback(checkpoint) ++
      for {size, steps} <- @estates,
          valid_agent?(player, size, steps) do
        {:agent, size}
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "landscaper"},
        built: {row, _},
        effect: nil,
        player: player,
        checkpoint: checkpoint
      }) do
    [:commit] ++
      rollback(checkpoint) ++
      cond do
        valid_park?(player, row) ->
          [:park]

        true ->
          []
      end
  end

  def moves(%{
        state: :playing,
        permit: %Card{suit: "surveyor"},
        built: {_, _},
        effect: nil,
        player: player,
        checkpoint: checkpoint
      }) do
    [:commit] ++
      rollback(checkpoint) ++
      for {row, index} <- @fences,
          valid_fence?(player, row, index) do
        {:fence, row, index}
      end
  end

  def moves(%{state: :playing, permit: %Card{}, built: {_, _}, checkpoint: checkpoint}) do
    [:commit] ++
      rollback(checkpoint)
  end

  def moves(%{state: :playing, permit: :refused, checkpoint: checkpoint}) do
    [:commit] ++
      rollback(checkpoint)
  end

  def moves(_state) do
    # e.g. state :gameover
    []
  end

  defp rollback(nil) do
    []
  end

  defp rollback(_checkpoint) do
    [:rollback]
  end

  def valid_permit?(player, [%Card{face: number, suit: "temp-agency"} | _]) do
    Enum.any?(@buildable, fn {row, index} ->
      Enum.any?([-2, -1, 0, 1, 2], fn offset ->
        valid_build?(player, row, index, number + offset)
      end)
    end)
  end

  def valid_permit?(player, [%Card{face: number} | _]) do
    Enum.any?(@buildable, fn {row, index} -> valid_build?(player, row, index, number) end)
  end

  def valid_permit?(_, nil) do
    false
  end

  def valid_build?(player, row, index, number) do
    unoccupied = fn x -> x !== nil end
    is_lower = fn x -> x < number end
    is_higher = fn x -> x > number end
    house_number = fn i -> Map.get(player, :"row#{row}#{i}number", 0) end

    Enum.all?([
      house_number.(index) === nil,
      1..index
      |> Enum.map(house_number)
      |> Enum.filter(unoccupied)
      |> Enum.all?(is_lower),
      index..@per_row[row]
      |> Enum.map(house_number)
      |> Enum.filter(unoccupied)
      |> Enum.all?(is_higher)
    ])
  end

  def valid_pool?(player, row, index) do
    !(Map.get(player, :"row#{row}#{index}pool", :invalid) in [true, :invalid])
  end

  def valid_bis?(player, row, index, offset) do
    existing = Map.get(player, :"row#{row}#{index + offset}number", :invalid)
    newbuild = Map.get(player, :"row#{row}#{index}number", :invalid)

    cond do
      # existing offset build is not a real index
      existing === :invalid -> false
      # existing build has not been built
      existing === nil -> false
      # new build is not a real index
      newbuild === :invalid -> false
      # new build has already been built
      newbuild !== nil -> false
      # fence exists between index and offset
      Map.get(player, :"fence#{row}#{min(index + offset, index)}", false) -> false
      # its cool
      true -> true
    end
  end

  def valid_agent?(player, size, steps) do
    Map.has_key?(steps, Map.get(player, :"estate#{size}"))
  end

  def valid_park?(player, row) do
    Map.has_key?(@landscaper[row], Map.get(player, :"park#{row}", :invalid))
  end

  def valid_fence?(player, row, index) do
    fence_slot = Map.get(player, :"fence#{row}#{index}", :invalid)
    left_number = Map.get(player, :"row#{row}#{index}number")
    right_number = Map.get(player, :"row#{row}#{index + 1}number")

    fence_slot === false and
      (left_number === nil or right_number === nil or left_number !== right_number)
  end

  def refusable([]) do
    [:refuse]
  end

  def refusable(moves) do
    moves
  end
end
