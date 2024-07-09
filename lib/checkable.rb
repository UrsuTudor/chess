# contains methods used by the Game class to determine whether or not the king is in check/check mate
module Checkable
  def check?
    if white_king.in_check?(board.board)
      puts "\nCheck!"
    elsif black_king.in_check?(board.board)
      puts "\nCheck!"
    end
  end

  def check_mate?
    if white_check_mate?
      puts "\nCheck mate, black wins!"
      return true
    elsif black_check_mate?
      puts "\nCheck mate, white wins!"
      return true
    end

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
    return if checker == false

    if black_king.possible_moves(board.board).empty?
      return true unless checker_can_be_taken?(checker) || checker_path_can_be_blocked?(checker, black_king)
    end

    false
  end

  def still_in_check?
    if turn == 'white' && white_king.in_check?(board.board) || turn == 'black' && black_king.in_check?(board.board)
      puts 'That move leaves your king in check!'
      return true
    end

    false
  end
end
