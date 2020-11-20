defmodule Tictac.Square do
  alias __MODULE__

  # enforce required arguments when creating this struct
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  def new(col, row) when col in 1..3 and row in 1..3 do
    {:ok, %Square{row: row, col: col}}
  end

  def new(col, row), do: {:error, :invalid_square}

  def new_board do
    for c <- 1..3, r <- 1..3, into: %{}, do:
      {%Square{col: c, row: r}, :empty}
  end
end