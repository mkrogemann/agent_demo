defmodule GamePrinterTest do
  use ExUnit.Case, async: true

  test "print/2: should produce a printout of the current game state" do
    game = Game.start_game("X")
    Game.move(game, 1, 1)
    Game.move(game, 2, 2)
    Game.move(game, 3, 3)
    new_state = Agent.get(game, fn state -> state end)
    {:ok, io}  = StringIO.open("")
    GamePrinter.print(new_state, io)

    assert StringIO.flush(io) == "\nGame state:\n\n  A | B | C \n1 X |   |  \n2   | O |  \n3   |   | X\n\nNext player: O"

    StringIO.close(io)
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
    GamePrinter.print(new_state, io)

    assert StringIO.flush(io) == "\nGame state:\n\n  A | B | C \n1 X | O |  \n2   | X |  \n3   | O | X\n\nGame over\n\nPlayer X wins!"

    StringIO.close(io)
  end

  test "print/2: should produce a printout for a game that is over and has no winner" do
    state = GameLogic.init("X",
                          ["X","O"," "],
                          ["X","O","O"],
                          ["O","X","X"])
    final_state = GameLogic.move(state, 1, 3)
    {:ok, io}  = StringIO.open("")
    GamePrinter.print(final_state, io)

    assert final_state.game_over
    assert StringIO.flush(io) == "\nGame state:\n\n  A | B | C \n1 X | O | X\n2 X | O | O\n3 O | X | X\n\nGame over\n\nNo winner :("

    StringIO.close(io)
  end
end
