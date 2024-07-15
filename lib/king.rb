require_relative 'piece'
require_relative 'knight'
require 'pry-byebug'
require_relative 'jsonable'

# manages the king piece
class King < Piece
  def initialize(player, row, col, has_moved = false)
    super(player, row, col)
    @white = '♚'
    @black = '♔'
    @has_moved = has_moved
    @in_check = false
  end

  # included to verify whether or not the king is in check from bishop/rook/queen
  include MoveableDiagonally
  include MoveableInStraightLine
  include JSONable

  attr_reader :white, :black, :player
  attr_accessor :has_moved, :in_check

  def possible_moves(board)
    king_moves = moves_on_lower_row + moves_on_same_row + moves_on_upper_row

    king_moves.push(castles(board))

    in_bounds_moves = exclude_out_of_bounds_moves(king_moves)

    non_allied_spaces = filter_allied_pieces(board, in_bounds_moves)

    non_checked_spaces = filter_checked_positions(board, non_allied_spaces)

    moves_next_to_opponent_king = moves_next_to_opponent_king(board, non_checked_spaces)

    non_checked_spaces.delete_if { |space| moves_next_to_opponent_king.include?(space) }
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

  def castles(board)
    return [row, col + 2] if castle_right?(board)

    [row, col - 2] if castle_left?(board)
  end

  def castle_right?(board)
    king_right = right_horizontal(board)

    return false if castle_path_blocked?(board, king_right)

    return false if has_moved == true || king_right.length < 2
    return true if row == 7 && board[row][col - 4].instance_of?(Rook) ||
                   row.zero? && board[row][col - 4].instance_of?(Rook)

    false
  end

  def castle_left?(board)
    king_left = left_horizontal(board)

    return false if castle_path_blocked?(board, king_left)

    return false if has_moved == true || king_left.length < 3
    return true if row == 7 && board[row][col + 3].instance_of?(Rook) ||
                   row.zero? && board[row][col + 3].instance_of?(Rook)

    false
  end

  def castle_path_blocked?(board, king_path)
    king_path.each do |square|
      simulated_king = King.new(player, square[0], square[1])

      return true if simulated_king.in_check?(board)
    end

    false
  end

  def filter_allied_pieces(board, possible_king_moves)
    possible_king_moves.delete_if { |move| allied_piece?(board, move[0], move[1]) }
  end

  def filter_checked_positions(board, possible_king_moves)
    # remembering them to change them back after the filtering is finished
    row_backup = row
    col_backup = col

    # this simulates a scenario in which the king is being moved to all the possible positions and verifies whether or
    # not the king would be in check
    possible_king_moves.delete_if do |move|
      self.row = move[0]
      self.col = move[1]

      in_check?(board)
    end

    # once the simulation is done, the king's coordinates need to be set back to its initial, real ones
    self.row = row_backup
    self.col = col_backup

    possible_king_moves
  end

  # checker added for readability, because the #check_from... methods return the checker if there is one
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

      cell = board[row][col]
      next if cell.nil?

      cell_row = cell.row
      cell_col = cell.col

      # this exists to fix a weird edge case with a queen that is right next to the king on the horizontal or vertical
      # line with no other pieces nearby; for a reason that remains unknown to me, #filter_checked_positions returns
      # true when it simulates the scenario in which the king's position is the same as the queen's position
      return false if path[0] == self.row && path[1] == self.col

      return cell if cell.instance_of?(Rook) && opponent_piece?(board, cell_row, cell_col) ||
                     cell.instance_of?(Queen) && opponent_piece?(board, cell_row, cell_col)
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
  def moves_next_to_opponent_king(board, possible_moves)
    spaces_next_to_enemy_king = []

    possible_moves.each do |square|
      simulated_king = King.new(player, square[0], square[1])

      # we are using a simulated king to check the area around a possible move of the real king
      # this means that if the king is on 3,3 and can move to 3,4, this will check every position around 3,4 and will
      # push 3,4 into the array above if 3,4 would place the real king next to the enemy king
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

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'player' => player,
      'row' => row,
      'col' => col,
      'white' => white,
      'black' => black,
      'has_moved' => has_moved
    }.to_json(*args)
  end
end
