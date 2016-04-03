defmodule Game do
  @moduledoc """
  Manages the game's state by use of an Elixir Agent.
  """

  @doc """
  Starts a new game.
  """
  def start_game(first_player) do
    initial_state = GameLogic.init(first_player)
    start_link(initial_state)
  end

  defp start_link(initial_state) do
    {:ok, pid} = Agent.start_link(fn -> initial_state end)
    pid
  end

  @doc """
  Executes a move for next player.
  """
  def move(game, row_num, column_num) do
    state = Agent.get(game, fn state -> state end)
    next_state = GameLogic.move(state, row_num, column_num)
    Agent.update(game, fn _state -> next_state end)
    next_state
  end
end
