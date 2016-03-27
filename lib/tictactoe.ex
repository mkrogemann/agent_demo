defmodule TicTacToe do
  @moduledoc """
  Implements the user interface.
  """

  @doc """
  Entry point: Starts a Game and then enters the process loop.
  """
  def main(_args) do
    game = Game.start_game("X")
    Game.print(get_game_state(game))
    process(game)
  end

  defp get_game_state(game) do
    Agent.get(game, fn state -> state end)
  end

  defp process(game) do
    IO.puts "\n"
    cmd = IO.gets "Command: "
    input = String.upcase(String.strip(cmd))
    case input do
      "NEW" -> new_game(game)
      "EXIT" -> terminate
      move ->
        if (get_game_state(game).game_over) do
          usage(game_over = true)
        else
          handle_move(move, game)
        end
        process(game)
    end
  end

  defp handle_move(move, game) do
    if Regex.match?(~r/^[A-C][1-3]$/, move) do
      IO.puts "\nEntered move: #{move}\n"
      next_state = Game.move(game, row_num(move), column_num(move))
      Game.print(next_state)
    else
      usage
      Game.print(get_game_state(game))
    end
  end

  defp row_num(input) do
    String.to_integer(String.at(input, 1))
  end

  defp column_num(input) do
    col_string = String.at(input, 0)
    case col_string do
      "A" -> 1
      "B" -> 2
      "C" -> 3
    end
  end

  defp new_game(game) do
    :ok = Agent.stop(game)
    next_game = Game.start_game("X")
    IO.puts "\nNew game\n"
    Game.print(get_game_state(next_game))
    process(next_game)
  end

  defp terminate() do
    IO.puts "\nBye\n"
    System.halt(0)
  end

  defp usage(game_over \\ false) do
    case game_over do
      true -> IO.puts "\nGame over. Please enter either 'new' or 'exit'"
      _ -> IO.puts "\nInvalid input. Please try again"
    end
  end
end
