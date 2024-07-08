require_relative 'piece'
require_relative 'board'
require 'pry-byebug'
require_relative 'jsonable'

# manages the pawn piece
class Pawn < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♙'
    @black = '♟︎'
    @has_moved = false
  end

  include JSONable

  attr_reader :white, :black, :player
  attr_accessor :has_moved

  def possible_moves(board)
    possible_moves = []

    if player == 'white'
      possible_moves.push(valid_one_forward_white(board))
      possible_moves.push(valid_doulbe_forward_white(board)) if has_moved == false
      valid_takes_white(board).each { |el| possible_moves.push(el) }
    else
      possible_moves.push(valid_one_forward_black(board))
      possible_moves.push(valid_doulbe_forward_black(board)) if has_moved == false
      valid_takes_black(board).each { |el| possible_moves.push(el) }
    end

    exclude_out_of_bounds_moves(possible_moves).delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
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

    valid_takes.push([row + 1, col + 1]) if opponent_piece?(board, row + 1, col + 1)

    valid_takes.push([row + 1, col - 1]) if opponent_piece?(board, row + 1, col - 1)

    valid_takes
  end

  def valid_takes_black(board)
    valid_takes = []

    valid_takes.push([row - 1, col + 1]) if opponent_piece?(board, row - 1, col + 1)

    valid_takes.push([row - 1, col - 1]) if opponent_piece?(board, row - 1, col - 1)

    valid_takes
  end

  def promote_pawn_white(board)
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
end
