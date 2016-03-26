defmodule GameLogicTest do
  use ExUnit.Case, async: true

  test "move/4: a legal move should update the game state" do
    initial_state = GameLogic.init
    next_state = GameLogic.move(initial_state, "X", 2, 2)

    assert initial_state.row_2 == [" ", " ", " "]
    assert next_state.row_2 == [" ", "X", " "]
    assert next_state.next_player == "O"
    assert ! next_state.game_over
  end

  test "move/4: an illegal move should be returned with the current game state" do
    initial_state = GameLogic.init
    next_state = GameLogic.move(initial_state, "X", 2, 2)

    assert GameLogic.move(next_state, "O", 2, 2) == next_state
    assert ! next_state.game_over
  end

  test "move/4: should set :game_over to true for winning move" do
    state = GameLogic.init("X",
                          ["X","O","X"],
                          ["O","X","O"],
                          ["O","X"," "])
    next_state = GameLogic.move(state, "X", 3, 3)

    assert GameLogic.player_wins?(next_state, "X")
    assert next_state.game_over
  end

  test "move/4: a move should not change the game state when :game_over is true" do
    state = GameLogic.init("X",
                          ["X","O"," "],
                          ["O","X"," "],
                          ["O","X"," "])
    next_state = GameLogic.move(state, "X", 3, 3)
    next_next_state = GameLogic.move(next_state, "O", 1, 3)

    assert next_state == next_next_state
    assert next_next_state.game_over
    assert GameLogic.player_wins?(next_next_state, "X")
  end

  test "player_wins?/2: should return false when game is not won for given player" do
    state = GameLogic.init("X",
                          ["X","O","X"],
                          ["O","X","O"],
                          ["O","X"," "])

    assert ! GameLogic.player_wins?(state, "O")
  end

  test "player_wins?/2: should return true when given player has completed a row" do
    state = GameLogic.init("X",
                          ["X","O","X"],
                          ["X","X"," "],
                          ["O","O","O"])

    assert GameLogic.player_wins?(state, "O")
  end

  test "player_wins?/2: should return true when player O has completed a column" do
    state = GameLogic.init("X",
                          ["X","O","X"],
                          ["X","O"," "],
                          ["O","O","X"])

    assert GameLogic.player_wins?(state, "O")
  end

  test "player_wins?/2: should return true when player X has completed a column" do
    state = GameLogic.init("O",
                          ["X","O"," "],
                          ["X","O"," "],
                          ["X"," "," "])

    assert GameLogic.player_wins?(state, "X")
  end

  test "player_wins?/2: should return true when given player has completed diagonal from bottom left" do
    state = GameLogic.init("X",
                          ["X","X","O"],
                          ["X","O"," "],
                          ["O","O","X"])

    assert GameLogic.player_wins?(state, "O")
  end

  test "player_wins?/2: should return true when given player has completed diagonal from top left" do
    state = GameLogic.init("X",
                          ["O","X","X"],
                          ["X","O"," "],
                          ["X","O","O"])

    assert GameLogic.player_wins?(state, "O")
  end
end
