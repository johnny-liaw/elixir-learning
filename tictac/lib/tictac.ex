defmodule Tictac do
  def new_board do
    for c <- 1..3, r <- 1..3, into: %{}, do:
      {%Square{col: c, row: r}, :empty}
  end

  def is_valid_player(player) do
    case player do
      :o -> {:ok, player}
      :x -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  def is_valid_square(board, square) do
    case board[square] do
      :empty -> {:ok, board, square}
      _ -> {:error, :invalid_square}
    end
  end

  def make_move(board, player, square) do
    with {:ok, player} <- is_valid_player(player),
      {:ok, baord, square} <- is_valid_square(board, square)
    do
      %{board | square => player}
    end
  end
end
