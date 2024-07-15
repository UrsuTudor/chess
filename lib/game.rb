require_relative 'board'
require_relative 'check_finder'
require_relative 'input_handler'

# tracks board state, turn and holds the methods needed to play the game
class Game
  def initialize
    @board = Board.new
    @white_king = board.board[0][4]
    @black_king = board.board[7][4]
    @turn = 'White'
    @check_finder = CheckFinder.new(board, white_king, black_king, turn)
    @input_handler = InputHandler.new(board, white_king, black_king, turn)
  end

  attr_accessor :turn, :board, :white_king, :black_king, :check_finder, :input_handler

  def play
    puts "\nYou can ask for a draw, save or to load your latest save
by typing the word in the console at any point."

    loop do
      # this needs to be here for when an old save is loaded
      update_helpers

      board.display_board

      puts "\n#{turn}'s turn!
      \nWhat piece would you like to move?"

      player_action = input_handler.validate_player_input

      break if input_handler.draw?(player_action)
      next if input_handler.save_or_load?(player_action, self)

      make_move(player_action)

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

      # the kings need to be updated for #still_in_check? of CheckFinder to work properly
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
    return handle_pawn(piece, row, col) if piece.instance_of?(Pawn)

    board.board[row][col] = piece
    board.board[piece.row][piece.col] = nil

    piece.row = row
    piece.col = col

    handle_pawn(piece, col) if piece.instance_of?(Pawn)
  end

  # diferent behaviour depending on whether or not the pawn has moved or has reached the finish
  def handle_pawn(pawn, new_row, new_col)
    board = self.board.board
    current_pawn_row = pawn.row
    current_pawn_col = pawn.col

    pawn.has_moved = true

    pawn.en_passantable = true if new_row == current_pawn_row + 2 || new_row == current_pawn_row - 2

    return perform_white_en_passant(pawn, new_row, new_col) if white_en_passant_requested?(pawn, new_row, new_col)
    return perform_black_en_passant(pawn, new_row, new_col) if black_en_passant_requested?(pawn, new_row, new_col)

    board[new_row][new_col] = pawn
    board[current_pawn_row][current_pawn_col] = nil

    pawn.row = new_row
    pawn.col = new_col

    # having them without an if statement is not a problem because a white pawn will never get to row 7 and a black pawn
    # will never get to row 0, so the methods will simply return if the pawn does not belong to the specified player
    pawn.promote_pawn_black(board)
    pawn.promote_pawn_white(board)
  end

  def perform_white_en_passant(pawn, new_row, new_col)
    board = self.board.board
    current_pawn_row = pawn.row
    current_pawn_col = pawn.col

    board[new_row][new_col] = pawn
    board[current_pawn_row][new_col] = nil
    board[current_pawn_row][current_pawn_col] = nil

    pawn.row = new_row
    pawn.col = new_col
  end

  def white_en_passant_requested?(pawn, new_row, new_col)
    current_pawn_row = pawn.row
    current_pawn_col = pawn.col

    return false unless  new_row == current_pawn_row + 1 && new_col == current_pawn_col + 1 ||
                         new_row == current_pawn_row + 1 && new_col == current_pawn_col - 1

    potential_en_passantable_pawn = board.board[current_pawn_row][new_col]

    return false unless potential_en_passantable_pawn.instance_of?(Pawn)

    return false unless potential_en_passantable_pawn.en_passantable

    true
  end

  def perform_black_en_passant(pawn, new_row, new_col)
    board = self.board.board
    current_pawn_row = pawn.row
    current_pawn_col = pawn.col

    board[new_row][new_col] = pawn
    board[current_pawn_row][new_col] = nil
    board[current_pawn_row][current_pawn_col] = nil

    pawn.row = new_row
    pawn.col = new_col
  end

  def black_en_passant_requested?(pawn, new_row, new_col)
    current_pawn_row = pawn.row
    current_pawn_col = pawn.col

    return false unless new_row == current_pawn_row - 1 && new_col == current_pawn_col + 1 ||
                        new_row == current_pawn_row - 1 && new_col == current_pawn_col - 1

    potential_en_passantable_pawn = board.board[current_pawn_row][new_col]

    return false unless potential_en_passantable_pawn.instance_of?(Pawn)

    return false unless potential_en_passantable_pawn.en_passantable

    true
  end
  # in the case of a castle, this only moves the rook; the regular #move_piece will move the king
  # the board needs to be updated only after the check for a castle is made, because the check uses the board, which is
  # why the #handle_king method needs to do its own board update after it performs the castle
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
    self.turn = if turn == 'White'
                  'Black'
                else
                  'White'
                end
  end
end
