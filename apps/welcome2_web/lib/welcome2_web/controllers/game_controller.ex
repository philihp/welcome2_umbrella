defmodule Welcome2Web.GameController do
  use Welcome2Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end

  def new(conn, _params) do
    game_conn = Welcome2Game.new_game()
    game_view = Welcome2Game.make_move(game_conn, {})
    moves = game_view[:moves]

    conn
    |> put_session(:game_conn, game_conn)
    |> assign(:game, game_view)
    |> assign(:moves, moves)
    |> assign(:action, "")
    |> render("new.html")
  end

  def advance(conn, params) do
    action =
      params["action"]
      |> String.split()
      |> to_move

    game_conn = get_session(conn, :game_conn)
    game_view = Welcome2Game.make_move(game_conn, action)
    moves = game_view[:moves]

    conn
    |> assign(:game, game_view)
    |> assign(:moves, moves)
    |> assign(:action, action)
    |> render("new.html")
  end

  defp to_move([]) do
    :identity
  end

  defp to_move([command]) do
    String.to_atom(command)
  end

  defp to_move([command | params]) do
    List.to_tuple([String.to_atom(command) | Enum.map(params, &to_param/1)])
  end

  defp to_param(param) when param in ["a", "b", "c"] do
    String.to_atom(param)
  end

  defp to_param(param) do
    param |> Integer.parse() |> to_num
  end

  defp to_num(:error) do
    999
  end

  defp to_num({digit, _}) do
    digit
  end
end
