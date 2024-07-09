# contains methods used to validate player input, whether it's checking the initial input, the piece the player selected
# or the coordinates the player wants to move it at
module Validateable
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
end
