defmodule TicTacToeTest do
  use ExUnit.Case

  import Mock

  test "valid_input?/1: make sure that only valid combinations get accepted as moves" do
    assert ! TicTacToe.valid_input?("")
    assert ! TicTacToe.valid_input?(" ")
    assert ! TicTacToe.valid_input?("ASDF")

    assert TicTacToe.valid_input?("A1")
    assert TicTacToe.valid_input?("B2")
    assert TicTacToe.valid_input?("C3")

    assert ! TicTacToe.valid_input?("B4")
    assert ! TicTacToe.valid_input?("D1")
  end

  test "handle_move/2: a valid move should get passed on to the Game module" do
    game = Game.start_game("X")
    move = "B2"
    dummy_state = GameLogic.init("X")
    {:ok, io} = StringIO.open("")
    with_mock Game, [move: fn(_game, _rnum, _cnum) -> dummy_state end] do
      TicTacToe.handle_move(move, game, io)

      assert called Game.move(game, 2, 2)
      assert StringIO.flush(io) == "\nEntered move: B2\n\nGame state:\n\n  A | B | C \n1   |   |  \n2   |   |  \n3   |   |  \n\nNext player: X"

      StringIO.close(io)
    end
  end

  test "handle_move/2: an invalid move should print usage and current game state" do
    game = Game.start_game("X")
    move = "ASDF"
    dummy_state = GameLogic.init("X")
    {:ok, io} = StringIO.open("")
    with_mock GamePrinter, [print: fn(_state, io) -> nil end] do
      TicTacToe.handle_move(move, game, io)

      assert called GamePrinter.print(dummy_state, io)
      assert StringIO.flush(io) == "\nInvalid input. Please try again"

      StringIO.close(io)
    end
  end
end
