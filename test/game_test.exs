defmodule GameTest do
  use ExUnit.Case, async: true

  test "start_game/1: should start an Agent that maintains the game state" do
    game = Game.start_game("X")
    state = Agent.get(game, fn state -> state end)

    assert is_pid game
    assert is_map state
    assert ! state.game_over
  end

  test "move/3: should update the state maintained by game agent" do
    game = Game.start_game("X")
    Game.move(game, 1, 1)
    new_state = Agent.get(game, fn state -> state end)

    assert new_state.next_player == "O"
    assert new_state.row_1 == ["X"," "," "]
  end
end
