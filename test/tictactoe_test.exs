defmodule TicTacToeTest do
  use ExUnit.Case, async: true

  test "" do
    assert ! TicTacToe.valid_input?("")
    assert ! TicTacToe.valid_input?(" ")
    assert ! TicTacToe.valid_input?("ASDF")

    assert TicTacToe.valid_input?("A1")
    assert TicTacToe.valid_input?("B2")
    assert TicTacToe.valid_input?("C3")

    assert ! TicTacToe.valid_input?("B4")
    assert ! TicTacToe.valid_input?("D1")
  end
  # test "new_game/1: should start a new game with a new underlying agent" do
  #   {:ok, io}  = StringIO.open("", capture_prompt: true)
  #   pid1 = Game.start_game("X")
  #   pid2 = TicTacToe.new_game(pid1, io)
  #
  #   assert pid2 != pid1
  #   assert ! Process.alive?(pid1)
  #   assert Process.alive?(pid2)
  #   StringIO.flush(io)
  #   StringIO.close(io)
  # end
end
