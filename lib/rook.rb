require_relative 'piece'
require 'pry-byebug'

# manages the rook piece
class Rook < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♜'
    @black = '♖'
  end

  attr_reader :white, :black, :player

  def possible_moves(board)
    exclude_out_of_bounds_moves(valid_horizontal(board) + valid_vertical(board))
  end

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

    right_horizontal
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

    left_horizontal
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

    upward_vertical
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

    downward_vertical
  end
end
