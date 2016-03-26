defmodule TicTacToe do

  @doc """
  Entry point: Starts a Game and then enters the process loop.
  """
  def main(_args) do
    game = Game.start_game("X")
    current_state = Agent.get(game, fn state -> state end)
    Game.print(current_state)
    process(game)
  end

  defp process(game) do
    current_state = Agent.get(game, fn state -> state end)
    IO.puts "\n"
    cmd = IO.gets "Command: "
    input = String.upcase(String.strip(cmd))
    case input do
      "NEW" -> new_game(game)
      "END" -> terminate
      move ->
        if (current_state.game_over) do
          usage(current_state.game_over)
        else
          handle_move(move, game)
        end
    end
    process(game)
  end

  defp handle_move(move, game) do
    if Regex.match?(~r/[A-C][1-3]/, move) do
      IO.puts "\nEntered move: #{move}\n"
      next_state = Game.move(game, row_num(move), column_num(move))
      Game.print(next_state)
    else
      usage
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
    IO.puts "\nNew game\n"
    :ok = Agent.stop(game)
    new_game = Game.start_game("X")
    Game.print(Agent.get(new_game, fn state -> state end))
    process(new_game)
  end

  defp terminate() do
    IO.puts "\nBye\n"
    System.halt(0)
  end

  defp usage(game_over \\ false) do
    case game_over do
      true -> IO.puts "\nGame over. Please enter either 'new' or 'end'"
      false -> IO.puts "\nInvalid input, please try again"
    end
  end
end
