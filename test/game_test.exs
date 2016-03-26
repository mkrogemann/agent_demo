defmodule GameTest do
  use ExUnit.Case, async: true

  test "start_game/1: should start an Agent that maintains the game state" do
    game = Game.start_game("X")
    state = Agent.get(game, fn state -> state end)

    assert is_pid game
    assert is_map state
    assert ! state.game_over
  end

  test "move/3: should update the state maintained by game Agent" do
    game = Game.start_game("X")
    Game.move(game, 1, 1)
    new_state = Agent.get(game, fn state -> state end)

    assert new_state.next_player == "O"
    assert new_state.row_1 == ["X"," "," "]
  end

  test "print/2: should produce a printout of the current game state" do
    game = Game.start_game("X")
    Game.move(game, 1, 1)
    Game.move(game, 2, 2)
    Game.move(game, 3, 3)
    new_state = Agent.get(game, fn state -> state end)
    {:ok, io}  = StringIO.open("")
    Game.print(new_state, io)

    assert StringIO.flush(io) == "\nGame state:\n\n  A | B | C \n1 X |   |  \n2   | O |  \n3   |   | X\n\nNext player: O"
  end

  test "print/2: should produce a printout for a game that is over and has a winner" do
    game = Game.start_game("X")
    Game.move(game, 1, 1)
    Game.move(game, 1, 2)
    Game.move(game, 2, 2)
    Game.move(game, 3, 2)
    Game.move(game, 3, 3)
    new_state = Agent.get(game, fn state -> state end)
    {:ok, io}  = StringIO.open("")
    Game.print(new_state, io)

    assert StringIO.flush(io) == "\nGame state:\n\n  A | B | C \n1 X | O |  \n2   | X |  \n3   | O | X\n\nGame over\n\nPlayer \"X\" wins!"
  end

  test "print/2: should produce a printout for a game that is over and has no winner" do
    state = GameLogic.init("X",
                          ["X","O"," "],
                          ["X","O","O"],
                          ["O","X","X"])
    final_state = GameLogic.move(state, "X", 1, 3)
    {:ok, io}  = StringIO.open("")
    Game.print(final_state, io)

    assert final_state.game_over
    assert StringIO.flush(io) == "\nGame state:\n\n  A | B | C \n1 X | O | X\n2 X | O | O\n3 O | X | X\n\nGame over\n\nNo winner :("
  end
end
