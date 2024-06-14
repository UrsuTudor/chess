class Piece
  def initialize(player, row, col)
    @player = player
    @row = row
    @col = col
  end
  attr_reader :player, :current_position

  def opponent_piece?(board, row, col)
    return false if board[row][col].nil?
    return false if player == 'white' && board[row][col].player == 'white'
    return false if player == 'black' && board[row][col].player == 'black'

    true
  end

  def allied_piece?(board, row, col)
    return false if board[row][col].nil?
    return true if player == 'white' && board[row][col].player == 'white'
    return true if player == 'black' && board[row][col].player == 'black'

    false
  end
end
