require_relative 'piece'
require_relative 'board'
require 'pry-byebug'
require_relative 'jsonable'

# manages the pawn piece
class Pawn < Piece
  def initialize(player, row, col, has_moved = false, en_passantable = false)
    super(player, row, col)
    @white = '♙'
    @black = '♟︎'
    @has_moved = has_moved
    @en_passantable = en_passantable
  end

  include JSONable

  attr_reader :white, :black, :player
  attr_accessor :has_moved, :en_passantable

  def possible_moves(board)
    possible_moves = if player == 'white'
                       white_moves(board)
                     else
                       black_moves(board)
                     end

    exclude_out_of_bounds_moves(possible_moves).delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
  end

  def white_moves(board)
    possible_moves = []

    possible_moves.push(valid_one_forward_white(board))

    possible_moves.push(valid_doulbe_forward_white(board)) if has_moved == false

    valid_takes_white(board).each { |el| possible_moves.push(el) }

    return possible_moves unless en_passant?(board)

    en_passantable_pawn = en_passant?(board)

    possible_moves.push([en_passantable_pawn.row + 1, en_passantable_pawn.col])
  end

  def black_moves(board)
    possible_moves = []

    possible_moves.push(valid_one_forward_black(board))

    possible_moves.push(valid_doulbe_forward_black(board)) if has_moved == false

    valid_takes_black(board).each { |el| possible_moves.push(el) }

    return possible_moves unless en_passant?(board)

    en_passantable_pawn = en_passant?(board)

    possible_moves.push([en_passantable_pawn.row - 1, en_passantable_pawn.col])
  end

  def valid_one_forward_white(board)
    [row + 1, col] unless allied_piece?(board, row + 1, col) || opponent_piece?(board, row + 1, col)
  end

  def valid_one_forward_black(board)
    [row - 1, col] unless allied_piece?(board, row - 1, col) || opponent_piece?(board, row - 1, col)
  end

  def valid_doulbe_forward_white(board)
    [row + 2, col] unless allied_piece?(board, row + 2, col) || allied_piece?(board, row + 1, col)
  end

  def valid_doulbe_forward_black(board)
    [row - 2, col] unless allied_piece?(board, row - 2, col) || allied_piece?(board, row - 1, col)
  end

  def valid_takes_white(board)
    valid_takes = []
    row = self.row
    col = self.col

    valid_takes.push([row + 1, col + 1]) if opponent_piece?(board, row + 1, col + 1)

    valid_takes.push([row + 1, col - 1]) if opponent_piece?(board, row + 1, col - 1)

    valid_takes
  end

  def valid_takes_black(board)
    valid_takes = []
    row = self.row
    col = self.col

    valid_takes.push([row - 1, col + 1]) if opponent_piece?(board, row - 1, col + 1)

    valid_takes.push([row - 1, col - 1]) if opponent_piece?(board, row - 1, col - 1)

    valid_takes
  end

  def promote_pawn_white(board)
    row = self.row
    col = self.col

    return unless row == 7

    puts 'What rank would you like to promote your pawn to?'
    promote_to = gets.chomp.downcase

    case promote_to
    when 'rook'
      board[row][col] = Rook.new('white', row, col)
    when 'bishop'
      board[row][col] = Bishop.new('white', row, col)
    when 'knight'
      board[row][col] = Knight.new('white', row, col)
    when 'queen'
      board[row][col] = Queen.new('white', row, col)
    else
      'Please choose a valid piece.'
    end
  end

  def promote_pawn_black(board)
    row = self.row
    col = self.col

    return unless row.zero?

    puts 'What rank would you like to promote your pawn to?'
    promote_to = gets.chomp.downcase

    case promote_to
    when 'rook'
      board[row][col] = Rook.new('black', row, col)
    when 'bishop'
      board[row][col] = Bishop.new('black', row, col)
    when 'knight'
      board[row][col] = Knight.new('black', row, col)
    when 'queen'
      board[row][col] = Queen.new('black', row, col)
    else
      'Please choose a valid piece.'
    end
  end

  def en_passant?(board)
    pawn_row = row
    pawn_col = col

    potential_enemy_pawns = [board[pawn_row][pawn_col - 1], board[pawn_row][pawn_col + 1]]

    potential_enemy_pawns.delete_if { |space| !space.instance_of?(Pawn) }

    return false if potential_enemy_pawns.empty?

    potential_enemy_pawns.each do |pawn|
      return pawn if pawn.en_passantable && opponent_piece?(board, pawn.row, pawn.col)
    end

    false
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'player' => player,
      'row' => row,
      'col' => col,
      'white' => white,
      'black' => black,
      'has_moved' => has_moved,
      'en_passantable' => en_passantable
    }.to_json(*args)
  end
end
