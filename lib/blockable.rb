module Blockable
  def checker_path_can_be_blocked?(checker, king)
    blockable_diagonally? if checker.instance_of?(Bishop) || checker.instance_of?(Queen)
  end

  def blockable_diagonally?(checker, king)
    checker_row = checker.row
    checker_col = checker.col

    king_row = king.row
    king_col = king.col

    return lower_diagonal_right_blockable?(checker, king) if checker_row > king_row && checker_col > king_col
    return lower_diagonal_left_blockable?(checker, king) if checker_row > king_row && checker_col < king_col

    return upper_diagonal_left_blockable?(checker, king) if checker_row < king_row && checker_col > king_col
    return upper_diagonal_right_blockable?(checker, king) if checker_row < king_row && checker_col < king_col

    blockable_by_pawn?(king)
  end

  def lower_diagonal_right_blockable?(checker, king)
    check_path = checker.descending_right_diagonal(board.board)

    check_path.each do |square|
      simulated_king = King.new(king.opposing_king(king), square[0], square[1])

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

  # used by blockable_by_pawn?
  def movable_unmoved_pawn?(unmoved_pawn, square_ahead_of_pawn)
    unmoved_pawn.instance_of?(Pawn) &&
      !unmoved_pawn.has_moved &&
      square_ahead_of_pawn.nil?
  end
end