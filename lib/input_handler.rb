require_relative 'saveable'
require_relative 'jsonable'

# contains methods used to validate player input, whether it's checking the initial input, the piece the player selected
# or the coordinates the player wants to move it at
class InputHandler
  def initialize(board, white_king, black_king, turn)
    @board = board
    @white_king = white_king
    @black_king = black_king
    @turn = turn
  end

  attr_reader :board, :turn, :white_king, :black_king

  include Saveable
  include JSONable

  def validate_player_input
    input = gets.chomp.split(',')

    input = input.join.downcase if input.length == 1

    if input =='draw' || input == 'save' || input == 'load'
      input
    elsif input.length == 2
      input.map { |num| num.to_i - 1 }
    else
      puts "Appropriate input is 'draw', 'save', 'load' or coordinates in this format: x,y"
      validate_player_input
    end
  end

  def valid_coordinates?(piece, coordinates)
    return false unless piece.possible_moves(board.board).include?(coordinates)

    true
  end

  def valid_piece?(piece)
    if piece.nil?
      puts 'That spot is empty!'
      return false
    elsif piece.possible_moves(board.board).empty?
      puts 'That piece cannot move at the moment!'
      return false
    elsif piece.player != turn
      puts 'That piece does not belong to you!'
      return false
    end

    true
  end

  def save_or_load?(player_action, game)
    if player_action == 'save'
      save_game
      puts "\nYour game was saved!"
      true
    elsif player_action == 'load'
      load_game(game)
      board.display_board
      puts "\nLast save was loaded!"
      true
    end
  end
end
