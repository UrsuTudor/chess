require 'pry-byebug'

module Blockable
  def checker_path_can_be_blocked?(checker, king)
    return blockable_diagonal?(checker, king) if checker.instance_of?(Bishop) || checker.instance_of?(Queen)

    return blockable_horizontal?(checker, king) if checker.instance_of?(Rook) || checker.instance_of?(Queen)

    blockable_vertical?(checker, king) if checker.instance_of?(Rook) || checker.instance_of?(Queen)
  end

  def blockable_diagonal?(checker, king)
    checker_row = checker.row
    checker_col = checker.col

    king_row = king.row
    king_col = king.col

    # all of these conditionals determine the direction from which the check is coming from so the appropriate diagonal
    # can be verified
    return lower_diagonal_right_blockable?(checker, king) if checker_row > king_row && checker_col > king_col
    return lower_diagonal_left_blockable?(checker, king) if checker_row > king_row && checker_col < king_col

    return upper_diagonal_left_blockable?(checker, king) if checker_row < king_row && checker_col > king_col
    upper_diagonal_right_blockable?(checker, king) if checker_row < king_row && checker_col < king_col
  end

  def lower_diagonal_right_blockable?(checker, king)
    check_path = checker.descending_right_diagonal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      # we want to exclude situations in which the simulated king would be in check from a pawn because that spot is
      # empty on the actual board and the pawn would not be able to move diagonally to block the check
      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def lower_diagonal_left_blockable?(checker, king)
    check_path = checker.descending_left_diagonal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def upper_diagonal_left_blockable?(checker, king)
    check_path = checker.ascending_left_diagonal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def upper_diagonal_right_blockable?(checker, king)
    check_path = checker.ascending_right_diagonal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def blockable_by_pawn?(king)
    if king.player == 'white'
      return true if blockable_by_white_pawn?(king)
    else
      return true if blockable_by_black_pawn?(king)
    end

    false
  end

  def blockable_by_white_pawn?(king)
    potential_unmoved_black_pawn = board.board[king.row + 2][king.col]
    potential_pawn = board.board[king.row + 1][king.col]

    return true if potential_pawn.instance_of?(Pawn) ||
                   movable_unmoved_pawn?(potential_unmoved_black_pawn, potential_pawn)

    false
  end

  def blockable_by_black_pawn?(king)
    potential_unmoved_white_pawn = board.board[king.row - 2][king.col]
    potential_pawn = board.board[king.row - 1][king.col]

    return true if potential_pawn.instance_of?(Pawn) ||
                   movable_unmoved_pawn?(potential_unmoved_white_pawn, potential_pawn)

    false
  end

  # used by blockable_by_pawn?
  def movable_unmoved_pawn?(unmoved_pawn, square_ahead_of_pawn)
    unmoved_pawn.instance_of?(Pawn) &&
      !unmoved_pawn.has_moved &&
      square_ahead_of_pawn.nil?
  end

  def blockable_horizontal?(checker, king)
    return unless checker.row == king.row

    checker_col = checker.col

    king_col = king.col

    return right_horizontal_blockable?(checker, king) if checker_col < king_col
    left_horizontal_blockable?(checker, king) if checker_col > king_col
  end

  def right_horizontal_blockable?(checker, king)
    check_path = checker.right_horizontal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def left_horizontal_blockable?(checker, king)
    check_path = checker.left_horizontal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def blockable_vertical?(checker, king)
    return unless checker.col == king.col

    checker_row = checker.row

    king_row = king.row

    return upper_vertical_blockable?(checker, king) if checker_row < king_row
    lower_diagonal_left_blockable?(checker, king) if checker_row > king_row
  end

  def upper_vertical_blockable?(checker, king)
    check_path = checker.upward_vertical(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end

  def lower_vertical_blockable?(checker, king)
    check_path = checker.downward_vertical(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

      return true if simulated_king.in_check?(board.board) &&
                     !simulated_king.in_check?(board.board).instance_of?(Pawn) ||
                     blockable_by_pawn?(simulated_king)
    end

    false
  end
end
