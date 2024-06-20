require './lib/moveable'
require './lib/king'
require './lib/rook'
require './lib/bishop'
require './lib/board'

describe King do
  subject(:king_white) { described_class.new('white', 0, 4) }
  subject(:king_black) { described_class.new('black', 7, 4) }
  let(:board) { Board.new }

  describe 'in_check?' do
    context 'when the king is checked by a rook on the vertical line' do
      it 'changes in_check to true for white king' do
        board.board[1][4] = nil
        board.board[5][4] = Rook.new('black', 5, 4)

        expect { king_white.in_check?(board.board) }.to change(king_white, :in_check).to true
      end

      it 'changes in_check to true for black king' do
        board.board[6][4] = nil
        board.board[3][4] = Rook.new('white', 3, 4)

        expect { king_black.in_check?(board.board) }.to change(king_black, :in_check).to true
      end
    end

    context 'when the king is checked by a rook on the horizontal line' do
      it 'changes in_check to true for white king' do
        board.board[0][5] = nil
        board.board[0][6] = Rook.new('black', 0, 6)

        expect { king_white.in_check?(board.board) }.to change(king_white, :in_check).to true
      end

      it 'changes in_check to true for black king' do
        board.board[7][5] = nil
        board.board[7][6] = Rook.new('white', 7, 6)

        expect { king_black.in_check?(board.board) }.to change(king_black, :in_check).to true
      end
    end

    context 'when the king has an allied rook by his side' do
      it 'does not trigger a false positive' do
        board.board[0][5] = nil
        board.board[0][6] = Rook.new('white', 0, 6)

        expect { king_white.in_check?(board.board) }.not_to change(king_white, :in_check)
      end
    end
  end

  context 'when the king is checked by a bishop on the upward-right' do
    it 'changes in_check to true for white king' do
      board.board[1][5] = nil
      board.board[2][6] = Bishop.new('black', 2, 6)

      expect { king_white.in_check?(board.board) }.to change(king_white, :in_check).to true
    end
  end

  context 'when the king is checked by a bishop on the lower-right' do
    it 'changes in_check to true for black king' do
      board.board[6][5] = nil
      board.board[5][6] = Bishop.new('white', 5, 6)

      expect { king_black.in_check?(board.board) }.to change(king_black, :in_check).to true
    end
  end

  context 'when the king is <<checked>> by an alied bishop' do
    it 'does not change in_check' do
      board.board[6][5] = nil
      board.board[5][6] = Bishop.new('black', 5, 6)

      expect { king_black.in_check?(board.board) }.to_not change(king_black, :in_check)
    end
  end
end
