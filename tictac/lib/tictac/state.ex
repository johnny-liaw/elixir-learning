defmodule Tictac.State do
  alias Tictac.{State, Square}

  @players [:x, :o]

  defstruct status: :initial,
            over: false,
            turn: nil, 
            winner: nil, 
            board: Square.new_board(),
            ui: nil


  def new(), do: {:ok, %State{}}
  def new(ui), do: {:ok, %State{ui: ui}}

  def event(%State{status: :initial} = state, {:choose_p1, player}) do
    case is_valid_player(player) do
      {:ok, p} -> {:ok, %State{state | status: :playing, turn: p}}
      _ -> {:error, :invalid_player}
    end 
  end

  def is_valid_player(player) do
    if player in @players do
      {:ok, player}
    else 
      {:error, :invalid_player}
    end
  end

  def event(%State{status: :playing} = state, {:play, p}) when p not in @players do
    {:error, :invalid_player}
  end

  def event(%State{status: :playing, turn: p} = state, {:play, p}) when p in @players do
    {:ok, %State{state | turn: other_player(p)}}
  end

  def event(%State{status: :playing} = state, {:play, _}), do: {:error, :out_of_turn}

  def event(%State{status: :playing} = state, {:check_for_winner, winner}) do
    case winner do
      :x -> {:ok, %State{state | status: :game_over, winner: winner}}
      :o -> {:ok, %State{state | status: :game_over, winner: winner}}
      _ -> {:error, :invalid_winner}
    end
  end

  def event(%State{status: :playing} = state, {:game_over?, over_or_not}) do
    case over_or_not do
      :not_over -> {:ok, state}
      :game_over -> {:ok, %State{state | status: :game_over, winner: :tie}}
      _ -> {:error, :invalid_game_over_status}
    end
  end

  def other_player(player) do
    case player do
      :x -> :o
      :o -> :x
      _ -> {:error, :invalid_player}
    end 
  end
end