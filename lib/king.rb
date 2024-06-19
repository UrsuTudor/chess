require_relative 'piece'
require 'pry-byebug'

# manages the king piece
class King < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♚'
    @black = '♔'
    @has_moved = false
    @in_check = false
  end

  # included to verify whether or not the king is in check
  include Moveable_diagonally
  include Moveable_in_straight_line

  attr_reader :white, :black, :player
  attr_accessor :has_moved, :in_check

  def possible_moves(board)
    king_moves = moves_on_lower_row + moves_on_same_row + moves_on_upper_row

    king_moves.push([row, col + 2]) if castle_right?(board)
    king_moves.push([row, col - 2]) if castle_left?(board)

    in_bounds_moves = exclude_out_of_bounds_moves(king_moves)

    in_bounds_moves.delete_if { |move| allied_piece?(board, move[0], move[1]) }
  end

  def moves_on_upper_row
    [[row + 1, col - 1], [row + 1, col], [row + 1, col + 1]]
  end

  def moves_on_same_row
    [[row, col - 1], [row, col + 1]]
  end

  def moves_on_lower_row
    [[row - 1, col - 1], [row - 1, col], [row - 1, col + 1]]
  end

  def castle_right?(board)
    return false if has_moved == true
    return true if row == 7 || row.zero? && board[row][col + 3].instance_of?(Rook)

    false
  end

  def castle_left?(board)
    return false if has_moved == true
    return true if row == 7 || row.zero? && board[row][col - 4].instance_of?(Rook)

    false
  end

  def check_for_checks(board)
    self.in_check = true if check_from_rook?(board)
    self.in_check = true if check_from_bishop?(board)
  end

  def check_from_rook?(board)
    rook_path_from_king = exclude_out_of_bounds_moves(valid_vertical(board) + valid_horizontal(board))

    rook_path_from_king.each do |element|
      row = element[0]
      col = element[1]
      piece = board[row][col]

      # it is not needed to check whether or not the Rook is an ally because an allied rook would never enter the array
      #  of valid moves
      if piece.instance_of?(Rook) || piece.instance_of?(Queen)
        puts "Check from #{piece.class} on #{row + 1}, #{col + 1}"
        return true
      end
    end

    false
  end

  def check_from_bishop?(board)
    bishop_path_from_king = exclude_out_of_bounds_moves(right_diagonal(board) + left_diagonal(board))
    bishop_path_from_king.each do |element|
      row = element[0]
      col = element[1]
      piece = board[row][col]

      if piece.instance_of?(Bishop) || piece.instance_of?(Queen)
        puts "Check from #{piece.class} on #{row + 1}, #{col + 1}"
        return true
      end
    end

    false
  end
end
