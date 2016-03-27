defmodule Game do

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
  Executes a move for given player.
  """
  def move(game, row_num, column_num) do
    state = Agent.get(game, fn state -> state end)
    next_state = GameLogic.move(state, state.next_player, row_num, column_num)
    Agent.update(game, fn _state -> next_state end)
    next_state
  end

  @doc """
  Print the given game state to stdout (default) or to a given
  IO device (e.g. StringIO).
  """
  def print(state, io_device \\ Process.group_leader()) do
    print_header(io_device)
    print_row(io_device, state.row_1, 1, true)
    print_row(io_device, state.row_2, 2, true)
    print_row(io_device, state.row_3, 3, true)
    print_footer(io_device, state)
  end

  defp print_header(io_device) do
    IO.write(io_device, "\nGame state:\n\n")
    IO.write(io_device, "  A | B | C \n")
  end

  defp print_row(io_device, row, row_nr, row_start \\ false) do
    if row_start do
      IO.write(io_device, Integer.to_string(row_nr))
    end
    case row do
      [] -> IO.write(io_device, "\n")
      [head|tail] ->
        IO.write(io_device, " " <> head)
        case tail do
          [_|_] -> IO.write(io_device, " |")
          _ -> nil
        end
        print_row(io_device, tail, row_nr)
    end
  end

  defp print_footer(io_device, state) do
    IO.write(io_device, "\n")
    if (state.game_over) do
      IO.write(io_device, "Game over\n")
      case state.winner do
        nil -> IO.write(io_device, "\nNo winner :(")
        player -> IO.write(io_device, "\nPlayer \"#{player}\" wins!")
      end
    else
      IO.write(io_device, "Next player: " <> state.next_player)
    end
  end
end
