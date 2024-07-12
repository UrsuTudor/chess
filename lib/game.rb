require_relative 'board'
require_relative 'saveable'
require_relative 'check_finder'
require_relative 'input_handler'

# tracks board state, turn and holds the methods needed to play the game
class Game
  def initialize
    @board = Board.new
    @white_king = board.board[0][4]
    @black_king = board.board[7][4]
    @turn = 'white'
    @check_finder = CheckFinder.new(board, white_king, black_king, turn)
    @input_handler = InputHandler.new(board, white_king, black_king, turn)
  end

  attr_accessor :turn, :board, :white_king, :black_king, :check_finder, :input_handler

  include Saveable

  def play
    board.display_board

    puts "\nYou can ask for a draw, save or to load your latest save
by typing the word in the console at any point."

    loop do
      # this needs to be here for when an old save is loaded
      update_helpers

      puts "\n#{turn.capitalize}'s turn!"
      puts "\nWhat piece would you like to move?"
      player_action = input_handler.validate_player_input

      break puts "\nYou have agreed to a draw!" if player_action == 'draw'
      next if input_handler.save_or_load?(player_action, self)

      make_move(player_action)
      board.display_board

      next_turn
      update_helpers

      break if check_finder.check_mate?
      check_finder.check?
    end
  end

  def update_helpers
    self.check_finder = CheckFinder.new(board, white_king, black_king, turn)
    self.input_handler = InputHandler.new(board, white_king, black_king, turn)
  end

  def choose_piece(input)
    piece = board.board[input[0]][input[1]]

    return piece if input_handler.valid_piece?(piece)

    different_piece
  end

  def different_piece
    loop do
      new_input = input_handler.validate_player_input
      next puts 'You cannot perform any other action until you move.' if new_input.instance_of?(String)

      piece = board.board[new_input[0]][new_input[1]]
      return piece if input_handler.valid_piece?(piece)
    end
  end

  def make_move(input)
    piece = choose_piece(input)

    # needed to change the coordinates of the piece back to their original ones if #still_in_check? returns true and
    # there is a need to roll back
    row_backup = piece.row
    col_backup = piece.col

    puts 'Where would you like to move the piece?'

    loop do
      coordinates = input_handler.validate_player_input
      next puts 'That move is illegal.' unless input_handler.valid_coordinates?(piece, coordinates)

      update_board(piece, coordinates[0], coordinates[1])
      # the kings need to be updated for #still_in_check? to work properly
      update_helpers

      different_move(piece, row_backup, col_backup, coordinates) if check_finder.still_in_check?
      break
    end
  end

  # used by make_move when the king would still be in check after the move chosen by the player
  def different_move(old_piece, row_backup, col_backup, old_coordinates)
    # reseting the old piece's data
    old_piece.row = row_backup
    old_piece.col = col_backup

    # reseting the board
    board.board[row_backup][col_backup] = old_piece
    board.board[old_coordinates[0]][old_coordinates[1]] = nil

    puts 'Select the same piece with a different move or a different piece, please!'

    new_input = input_handler.validate_player_input
    make_move(new_input)
  end

  def update_board(piece, row, col)
    return handle_king(piece, row, col) if piece.instance_of?(King)

    board.board[row][col] = piece
    board.board[piece.row][piece.col] = nil

    piece.row = row
    piece.col = col

    handle_pawn(piece) if piece.instance_of?(Pawn)
  end

  # diferent behaviour depending on whether or not the pawn has moved or has reached the finish
  def handle_pawn(pawn)
    pawn.has_moved = true
    # having them like this is not a problem because a white pawn will never get to row 7 and a black pawn will never
    # get to row 0, so the methods will simply return if the pawn does not belong to the specified player
    pawn.promote_pawn_black(board.board)
    pawn.promote_pawn_white(board.board)
  end

  # in the case of a castle, this only moves the rook; the regular #move_piece will move the king
  # the board can only be updated after the check for a castle is made, because the check uses the board, which is why
  # the #handle_king method needs to do its own board update after it performs the castle
  def handle_king(king, row, col)
    board = self.board.board

    do_castle_right(board, row, col) if king.castle_right?(board)
    do_castle_left(board, row, col) if king.castle_left?(board)

    board[row][col] = king
    board[king.row][king.col] = nil

    king.row = row
    king.col = col

    king.has_moved = true
    update_game_king(king)
  end

  # the kings do not update themselves automatically, but it is important to have them updated for the methods that
  # look for checks
  def update_game_king(king)
    if king.player == 'white'
      self.white_king = king
    else
      self.black_king = king
    end
  end

  # deleting the old Rook and placing a new one is easier and faster than creating a new movement exception for the Rook
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

  def next_turn
    self.turn = if turn == 'white'
                  'black'
                else
                  'white'
                end
  end
end
