defmodule GameLogic do

  @doc """
  Initialize a game state. Allows to give an initial state that is different
  from a new game. Also allows specification of first player.
  Please note that the params exist mainly for testability.
  """
  def init(next_player \\ "X",
           row_1 \\ [" ", " ", " "],
           row_2 \\ [" ", " ", " "],
           row_3 \\ [" ", " ", " "]) do
    %{ :row_1 => row_1, :row_2 => row_2,
       :row_3 => row_3, :next_player => next_player,
       :game_over => false, :winner => nil }
  end

  @doc """
  Executes a move for given player and given state.
  """
  def move(state, player, row_num, column_num) do
    row_key = row_key(row_num)
    row = Map.get(state, row_key)
    illegal_move = Enum.at(row, column_num - 1) != " "
    if (illegal_move || state.game_over) do
      state
    else
      update_state(state, player, row, column_num, row_key)
    end
  end

  defp row_key(row_num) do
    String.to_atom("row_" <> Integer.to_string(row_num))
  end

  defp update_state(state, player, row, column_num, row_key) do
    updated_row = List.replace_at(row, column_num - 1, player)
    new_state = %{ state | row_key => updated_row }
    if (player_wins?(new_state, player)) do
      %{ new_state | :game_over => true, :winner => player }
    else
      if (all_filled?(new_state)) do
        %{ new_state | :game_over => true }
      else
        %{ new_state | :next_player => next_player(player) }
      end
    end
  end

  @doc """
  This function allows to determine if given player has won the game
  that is given by its state.
  """
  def player_wins?(state, player) do
    row_complete = Enum.any?([1, 2, 3], fn(r) -> row_complete(state, r, player) end)
    column_complete = Enum.any?([0, 1, 2], fn(c) -> column_complete(state, c, player) end)
    row_complete || column_complete || diagonal_complete(state, player)
  end

  defp row_complete(state, row_num, player) do
    row = Map.get(state, row_key(row_num))
    Enum.all?(row, fn(elem) -> elem == player end)
  end

  defp column_complete(state, col_num, player) do
    column = [Enum.at(Map.get(state, row_key(1)), col_num),
              Enum.at(Map.get(state, row_key(2)), col_num),
              Enum.at(Map.get(state, row_key(3)), col_num)]
    Enum.all?(column, fn(elem) -> elem == player end)
  end

  defp diagonal_complete(state, player) do
    from_top_left     = [Enum.at(Map.get(state, row_key(1)), 0),
                         Enum.at(Map.get(state, row_key(2)), 1),
                         Enum.at(Map.get(state, row_key(3)), 2)]
    from_bottom_left  = [Enum.at(Map.get(state, row_key(3)), 0),
                         Enum.at(Map.get(state, row_key(2)), 1),
                         Enum.at(Map.get(state, row_key(1)), 2)]
    Enum.all?(from_top_left, fn(elem) -> elem == player end)
    || Enum.all?(from_bottom_left, fn(elem) -> elem == player end)
  end

  defp all_filled?(state) do
    Enum.all?([1, 2, 3], fn(row_num) ->
      row = Map.get(state, row_key(row_num))
      Enum.all?(row, fn(elem) -> elem != " " end)
    end)
  end

  defp next_player("X") do "O"; end
  defp next_player("O") do "X"; end
end
