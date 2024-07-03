require_relative 'piece'
require_relative 'knight'
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

  # included to verify whether or not the king is in check from bishop/rook/queen
  include Moveable_diagonally
  include Moveable_in_straight_line

  attr_reader :white, :black, :player
  attr_accessor :has_moved, :in_check

  def possible_moves(board)
    king_moves = moves_on_lower_row + moves_on_same_row + moves_on_upper_row

    king_moves.push(castles(board))

    in_bounds_moves = exclude_out_of_bounds_moves(king_moves)

    non_allied_spaces = filter_allied_pieces(board, in_bounds_moves)

    non_checked_spaces = filter_checked_positions(board, non_allied_spaces)

    moves_next_to_king = moves_next_to_opponent_king(board, non_checked_spaces)

    non_checked_spaces.delete_if { |space| moves_next_to_king.include?(space) }
  end

  def castles(board)
    [row, col + 2] if castle_right?(board)
    [row, col - 2] if castle_left?(board)
  end

  def filter_checked_positions(board, possible_king_moves)
    # remembering them to change them back after the filtering is finished
    row_on_board = row
    col_on_board = col

    # this simulates a scenario in which the king is being moved to all the possible positions and verifies whether or
    # not the king would be in check
    possible_king_moves.delete_if do |move|
      self.row = move[0]
      self.col = move[1]

      in_check?(board)
    end

    # once the simulation is done, the king's coordinates need to be set back to its initial, real ones
    self.row = row_on_board
    self.col = col_on_board

    possible_king_moves
  end

  def filter_allied_pieces(board, possible_king_moves)
    possible_king_moves.delete_if { |move| allied_piece?(board, move[0], move[1]) }
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

  def in_check?(board)
    if check_from_rook?(board)
      self.in_check = true
      checker = check_from_rook?(board)
    elsif check_from_bishop?(board)
      self.in_check = true
      checker = check_from_bishop?(board)
    elsif check_from_knight?(board)
      self.in_check = true
      checker = check_from_knight?(board)
    elsif check_from_pawn?(board)
      self.in_check = true
      checker = check_from_pawn?(board)
    else
      self.in_check = false
      false
    end
  end

  def check_from_rook?(board)
    rook_path_from_king = exclude_out_of_bounds_moves(valid_vertical(board) + valid_horizontal(board))

    rook_path_from_king.each do |path|
      row = path[0]
      col = path[1]

      piece = board[row][col]

      # this exists to fix a weird edge case in which a queen that is right next to the king on the horizontal or vertical
      # line with no other pieces nearby, will return true when #filter_checked_positions runs the simulation and it
      # simulates a scenario in which the king's position is the same as the queen's position
      return false if path[0] == self.row && path[1] == self.col

      # it is not needed to check whether or not the Rook is an ally because an allied rook would never enter the array
      #  of valid moves
      return piece if piece.instance_of?(Rook) || piece.instance_of?(Queen)
    end

    false
  end

  def check_from_bishop?(board)
    bishop_path_from_king = exclude_out_of_bounds_moves(right_diagonal(board) + left_diagonal(board))

    bishop_path_from_king.each do |path|
      row = path[0]
      col = path[1]
      piece = board[row][col]

      return piece if piece.instance_of?(Bishop) || piece.instance_of?(Queen)
    end

    false
  end

  def check_from_knight?(board)
    knight_path_from_king = Knight.new(player, row, col).possible_moves(board)

    knight_path_from_king.each do |path|
      row = path[0]
      col = path[1]
      piece = board[row][col]

      return piece if piece.instance_of?(Knight)
    end

    false
  end

  def check_from_pawn?(board)
    pawn_path_from_king = exclude_out_of_bounds_moves(pawn_attacks)

    pawn_path_from_king.each do |path|
      row = path[0]
      col = path[1]
      piece = board[row][col]

      return piece if piece.instance_of?(Pawn) && opponent_piece?(board, row, col)
    end

    false
  end

  # this was made for the #checker_can_be_taken? method in the Game class, so I can check whether or not the checker
  # can be taken by the king
  def check_from_king?(board)
    area_around_king = moves_on_lower_row + moves_on_same_row + moves_on_upper_row

    area_around_king.each do |square|
      row = square[0]
      col = square[1]
      piece = board[row][col]

      return piece if piece.instance_of?(King) && opponent_piece?(board, row, col)
    end

    false
  end

  # returns an array of moves that would place the king next to the enemy king
  def moves_next_to_opponent_king(board, non_checked_spaces)
    spaces_next_to_enemy_king = []

    non_checked_spaces.each do |square|
      simulated_king = King.new(player, square[0], square[1])

      simulated_king_moves(board, simulated_king).each do |space|
        if board[space[0]][space[1]].instance_of?(King)
          spaces_next_to_enemy_king.push([simulated_king.row, simulated_king.col])
        end
      end
    end

    spaces_next_to_enemy_king
  end

  # this is the same as the possible_moves method for the regular king but without the moves_next_to_opponent_king step,
  # since moves_next_to_opponent_king requires it to work
  def simulated_king_moves(board, simulated_king)
    area_around_square = simulated_king.moves_on_lower_row +
                         simulated_king.moves_on_same_row +
                         simulated_king.moves_on_upper_row

    in_bounds_moves = exclude_out_of_bounds_moves(area_around_square)

    non_allied_spaces = simulated_king.filter_allied_pieces(board, in_bounds_moves)

    filter_checked_positions(board, non_allied_spaces)
  end

  def pawn_attacks
    king_row = row
    king_col = col

    return [[king_row + 1, king_col + 1], [king_row + 1, king_col - 1]] if player == 'white'

    [[king_row - 1, king_col + 1], [king_row - 1, king_col - 1]] if player == 'black'
  end

  def opposing_king(king)
    if king.player == 'white'
      'black'
    else
      'white'
    end
  end
end
