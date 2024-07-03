require 'pry-byebug'
module Moveable_diagonally
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

    diagonal.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
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

    diagonal.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
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

    diagonal.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
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

    diagonal.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
  end
end

module Moveable_in_straight_line
  def valid_horizontal(board)
    exclude_out_of_bounds_moves(left_horizontal(board) + right_horizontal(board))
  end

  def right_horizontal(board)
    right_horizontal = []
    col_of_space = col

    board[row][col + 1..].each do |space|
      # if the space is nil, we can't invoke space.col, so we need to add up the col_of_space to get the proper col
      next right_horizontal.push([row, col_of_space += 1]) if space.nil?

      # here we could add up col_of_space again, which would be slightly more efficient, but it makes the reading more
      # difficult
      break if allied_piece?(board, row, space.col)

      break right_horizontal.push([row, space.col]) if opponent_piece?(board, row, space.col)
    end

    right_horizontal.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
  end

  def left_horizontal(board)
    left_horizontal = []
    col_of_space = col

    # the left slice of the horizontal needs to be reversed to we start iterating from the position of the rook, not
    # from col 0
    board[row][0...col].reverse.each do |space|
      next left_horizontal.push([row, col_of_space -= 1]) if space.nil?

      break if allied_piece?(board, row, space.col)

      break left_horizontal.push([row, space.col]) if opponent_piece?(board, row, space.col)
    end

    left_horizontal.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
  end

  def valid_vertical(board)
    exclude_out_of_bounds_moves(downward_vertical(board) + upward_vertical(board))
  end

  def upward_vertical(board)
    upward_vertical = []
    current_row = row

    until current_row == 7
      current_row += 1

      next upward_vertical.push([current_row, col]) if board[current_row][col].nil?

      break if allied_piece?(board, current_row, col)

      break upward_vertical.push([current_row, col]) if opponent_piece?(board, current_row, col)
    end

    upward_vertical.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
  end

  def downward_vertical(board)
    downward_vertical = []

    current_row = row

    until current_row.zero?
      current_row -= 1

      next downward_vertical.push([current_row, col]) if board[current_row][col].nil?

      break if allied_piece?(board, current_row, col)

      break downward_vertical.push([current_row, col]) if opponent_piece?(board, current_row, col)
    end

    downward_vertical.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
  end
end
