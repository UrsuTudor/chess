require_relative 'board'
require_relative 'blockable'
require_relative 'jsonable'
require 'json'
require 'erb'

class Game
  def initialize
    @board = Board.new
    @white_king = board.board[0][4]
    @black_king = board.board[7][4]
    @turn = 'white'
  end

  attr_accessor :turn, :board, :white_king, :black_king

  include Blockable
  include JSONable

  def play
    board.display_board

    puts "\nYou can ask for a draw, save or load your latest save
by typing the game by typing the word in the console."

    loop do
      puts "\n#{turn.capitalize}'s turn!"

      player_action = player_input

      return puts 'You have agreed to a draw!' if player_action == 'draw'

      if player_action == 'save'
        save_game
        puts 'Your game was saved!'
        next
      elsif player_action == 'load'
        load_game
        board.display_board
        puts 'Last save was loaded!'
        next
      end

      move_piece(player_action)

      board.display_board

      if white_king.in_check?(board.board)
        puts 'check'
        break puts 'Check mate, black wins!' if white_check_mate?
      end

      if black_king.in_check?(board.board)
        puts 'check'
        break puts 'Check mate, white wins!' if black_check_mate?
      end

      next_turn
    end
  end

  def save_game
    serialized_game = JSON.dump({ board: board.board.each do |row|
      row.each do |col|
        col.to_json
      end
    end,
                                  white_king:,
                                  black_king:,
                                  turn: })

    File.open('save.json', 'w') do |file|
      file.puts serialized_game
    end
  end

  # JSON.parse(serialized_game)['board']
  def load_game
    save_file = File.read('save.json')
    data = JSON.parse(save_file)

    board.board = data['board'].map do |row|
      row.map do |col|
        class_from_json(col) unless col.nil?
      end
    end

    self.white_king = class_from_json(data['white_king'])
    self.black_king = class_from_json(data['black_king'])
    self.turn = data['turn']
  end

  def checker_can_be_taken?(checker)
    simulated_king = King.new(checker.player, checker.row, checker.col)

    return true if simulated_king.in_check?(board.board) || simulated_king.check_from_king?(board.board)

    false
  end

  def white_check_mate?
    checker = white_king.in_check?(board.board)

    if white_king.possible_moves(board.board).empty?
      return true unless checker_can_be_taken?(checker) || checker_path_can_be_blocked?(checker, white_king)
    end

    false
  end

  def black_check_mate?
    checker = black_king.in_check?(board.board)

    if black_king.possible_moves(board.board).empty?
      return true unless checker_can_be_taken?(checker) || checker_path_can_be_blocked?(checker, black_king)
    end

    false
  end

  def move_piece(input)
    piece = choose_piece(input)

    puts 'Where would you like to move the piece?'

    loop do
      coordinates = player_input
      next puts 'That move is illegal.' unless valid_coordinates?(piece, coordinates)

      board_backup = board.board
      update_board(piece, coordinates[0], coordinates[1])

      different_move(board_backup) if still_in_check?
      break
    end
  end

  def still_in_check?
    if turn == 'white' && white_king.in_check?(board.board) || turn == 'black' && black_king.in_check?(board.board)
      puts 'That move leaves your king in check!'
      return true
    end

    false
  end

  def different_move(board_backup)
    board.board = board_backup
    new_input = player_input
    move_piece(new_input)
  end

  def choose_piece(input)
    loop do
      if valid_piece?(board.board[input[0]][input[1]])
        piece = board.board[input[0]][input[1]]
      else
        puts 'What piece would you like to move?'
        new_input = player_input
        piece = board.board[new_input[0]][new_input[1]]
      end

      next unless valid_piece?(piece)

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

  def player_input
    coordinates = gets.chomp.split(',')

    return coordinates.join if coordinates.join == 'draw'
    return coordinates.join if coordinates.join == 'save'
    return coordinates.join if coordinates.join == 'load'

    coordinates.map { |num| num.to_i - 1 }
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

  def next_turn
    self.turn = if turn == 'white'
                  'black'
                else
                  'white'
                end
  end
end
