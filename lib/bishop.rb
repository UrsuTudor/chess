require_relative 'piece'

# manages the bishop piece
class Bishop < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♝'
    @black = '♗'
  end

  attr_reader :white, :black, :player

  def possible_moves(board)
    exclude_out_of_bounds_moves(right_diagonal(board) + left_diagonal(board))
  end

  def right_diagonal(board)
    descending_right_diagonal(board) + ascending_right_diagonal(board)
  end

  def ascending_right_diagonal(board)
    diagonal = []
    current_row = row
    current_col = col

    until current_row == 7
      current_row += 1
      current_col += 1

      next diagonal.push([current_row, current_col]) if board[current_row][current_col].nil?

      break diagonal.push([current_row, current_col]) if opponent_piece?(board, current_row, current_col)

      break if allied_piece?(board, current_row, current_col)
    end

    diagonal
  end

  def descending_right_diagonal(board)
    diagonal = []
    current_row = row
    current_col = col

    until current_row.negative?
      current_row -= 1
      current_col -= 1

      next diagonal.push([current_row, current_col]) if board[current_row][current_col].nil?

      break diagonal.push([current_row, current_col]) if opponent_piece?(board, current_row, current_col)

      break if allied_piece?(board, current_row, current_col)
    end

    diagonal
  end

  def left_diagonal(board)
    ascending_left_diagonal(board) + descending_left_diagonal(board)
  end

  def ascending_left_diagonal(board)
    diagonal = []
    current_row = row
    current_col = col

    until current_row == 7
      current_row += 1
      current_col -= 1

      next diagonal.push([current_row, current_col]) if board[current_row][current_col].nil?

      break diagonal.push([current_row, current_col]) if opponent_piece?(board, current_row, current_col)

      break if allied_piece?(board, current_row, current_col)
    end

    diagonal
  end

  def descending_left_diagonal(board)
    diagonal = []
    current_row = row
    current_col = col

    until current_row.negative?
      current_row -= 1
      current_col += 1

      next diagonal.push([current_row, current_col]) if board[current_row][current_col].nil?

      break diagonal.push([current_row, current_col]) if opponent_piece?(board, current_row, current_col)

      break if allied_piece?(board, current_row, current_col)
    end

    diagonal
  end
end
