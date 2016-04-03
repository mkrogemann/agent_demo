defmodule GamePrinter do
  @moduledoc """
  Provides a printer for the game grid.
  """
  
  @doc """
  Print the given game state to stdout (default) or to a given
  IO device (e.g. StringIO).
  """
  def print(state, io_device \\ Process.group_leader()) do
    print_header(io_device)
    print_row(io_device, state.row_1, 1)
    print_row(io_device, state.row_2, 2)
    print_row(io_device, state.row_3, 3)
    print_footer(io_device, state)
  end

  defp print_header(io_device) do
    IO.write(io_device, "\nGame state:\n\n")
    IO.write(io_device, "  A | B | C \n")
  end

  defp print_row(io_device, row, row_nr) do
    IO.write(io_device, Integer.to_string(row_nr))
    _print_row(io_device, row, row_nr)
  end

  defp _print_row(io_device, row, row_nr) do
    case row do
      [] -> IO.write(io_device, "\n")
      [head|tail] ->
        IO.write(io_device, " " <> head)
        case tail do
          [_|_] -> IO.write(io_device, " |")
          _ -> nil
        end
        _print_row(io_device, tail, row_nr)
    end
  end

  defp print_footer(io_device, state) do
    IO.write(io_device, "\n")
    if (state.game_over) do
      IO.write(io_device, "Game over\n")
      case state.winner do
        nil -> IO.write(io_device, "\nNo winner :(")
        player -> IO.write(io_device, "\nPlayer #{player} wins!")
      end
    else
      IO.write(io_device, "Next player: " <> state.next_player)
    end
  end
end
