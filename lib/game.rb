require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @white_king = board.board[0][4]
    @black_king = board.board[7][4]
  end

  attr_reader :board, :white_king, :black_king

  def play
    board.display_board
    loop do
      move_piece
      board.display_board
      if white_king.in_check?(board.board)
        puts 'check'
        break puts 'Check mate, black wins!' if check_mate? && !checker_can_be_taken?(white_king.in_check?(board.board))
      end

      if black_king.in_check?(board.board)
        puts 'check'
        break puts 'Check mate, white wins!' if check_mate?
      end
    end
  end

  def checker_can_be_taken?(checker)
    simulated_king = King.new(checker.player, checker.row, checker.col)

    return true if simulated_king.in_check?(board.board) || simulated_king.check_from_king?(board.board)

    false
  end

  def checker_path_can_be_blocked?(checker, king)
    if checker.instance_of?(Bishop) || checker.instance_of?(Queen)
      lower_diagonal_right_blockable?(checker, king)
    end
  end

  def lower_diagonal_right_blockable?(checker, king)
    checker_row = checker.row
    checker_col = checker.col

    king_row = king.row
    king_col = king.col

    return unless checker_row > king_row && checker_col > king_col

    check_path = checker.descending_right_diagonal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def simulate_opposing_king(king, row, col)
    King.new(king.opposing_king(king), row, col)
  end

  def blockable_by_pawn?(king)
    if king.player == 'white'
      potential_unmoved_black_pawn = board.board[king.row + 2][king.col]
      potential_pawn = board.board[king.row + 1][king.col]

      return true if potential_pawn.instance_of?(Pawn) ||
                     movable_unmoved_pawn?(potential_unmoved_black_pawn, potential_pawn)
    else
      potential_unmoved_white_pawn = board.board[king.row - 2][king.col]
      potential_pawn = board.board[king.row - 1][king.col]

      return true if potential_pawn.instance_of?(Pawn) ||
                     movable_unmoved_pawn?(potential_unmoved_white_pawn, potential_pawn)
    end

    false
  end

  def movable_unmoved_pawn?(unmoved_pawn, square_ahead_of_pawn)
    unmoved_pawn.instance_of?(Pawn) &&
      !unmoved_pawn.has_moved &&
      square_ahead_of_pawn.nil?
  end

  def check_mate?
    return true if white_king.possible_moves(board.board).empty?
    return true if black_king.possible_moves(board.board).empty?

    false
  end

  def move_piece
    piece = choose_piece

    puts 'Where would you like to move the piece?'

    loop do
      coordinates = player_coordinates
      next puts 'That move is illegal.' unless valid_input?(piece, coordinates)

      update_board(piece, coordinates[0], coordinates[1])
      break
    end
  end

  def choose_piece
    loop do
      puts 'What piece would you like to move?'
      piece = player_coordinates
      piece = board.board[piece[0]][piece[1]]

      next puts 'That spot is empty!' if piece.nil?
      next puts 'That piece cannot move at the moment!' if piece.possible_moves(board.board).empty?

      return piece
    end
  end

  def update_board(piece, row, col)
    # set handle king to only move the rook and let the regular update board function move the king
    handle_king(piece, row, col) if piece.instance_of?(King)

    board.board[row][col] = piece
    board.board[piece.row][piece.col] = nil

    piece.row = row
    piece.col = col

    handle_pawn(piece) if piece.instance_of?(Pawn)
  end

  def handle_pawn(pawn)
    pawn.has_moved = true
    # having them like this is not a problem because a white pawn will never get to row 7 and a black pawn will never
    # get to row 0, so the methods will simply return if the pawn does not belong to the specified player
    pawn.promote_pawn_black(board.board)
    pawn.promote_pawn_white(board.board)
  end

  def handle_king(king, row, col)
    return if king.has_moved == true

    do_castle_right(board.board, row, col) if king.castle_right?(board.board)
    do_castle_left(board.board, row, col) if king.castle_left?(board.board)

    king.has_moved = true
  end

  def do_castle_right(board, row, col)
    return unless row == 7 && col == 6 || row.zero? && col == 6

    board[row][5] = Rook.new(board[row][7].player, row, 7)
    board[row][7] = nil
  end

  def do_castle_left(board, row, col)
    return unless row == 7 && col == 2 || row.zero? && col == 2

    board[row][3] = Rook.new(board[row][0].player, row, 3)
    board[row][0] = nil
  end

  def player_coordinates
    gets.chomp.split(',').map { |num| num.to_i - 1 }
  end

  def valid_input?(piece, coordinates)
    return false unless piece.possible_moves(board.board).include?(coordinates)

    true
  end
end
