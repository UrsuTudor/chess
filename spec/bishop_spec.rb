require './lib/bishop'
require './lib/board'

describe Bishop do
  subject(:bishop) { described_class.new('white', 5, 4) }
  let(:board) { Board.new }

  describe 'possible_moves' do
    context 'when the diagonals are empty' do
      it 'returns an array containing the diagonals' do
        board.board[6][5] = nil
        board.board[7][6] = nil
        board.board[4][3] = nil
        board.board[3][2] = nil
        board.board[2][1] = nil
        board.board[1][0] = nil
        board.board[4][5] = nil
        board.board[3][6] = nil
        board.board[2][7] = nil
        board.board[6][3] = nil
        board.board[7][2] = nil
        expect(bishop.possible_moves(board.board)).to eq([[4, 3], [3, 2], [2, 1], [1, 0], [6, 5], [7, 6], [6, 3],
                                                          [7, 2], [4, 5], [3, 6], [2, 7]])
      end
    end

    context 'when the n-e diagonal is occupied by an ally right next to the bishop' do
      it 'returns an array containing the diagonals without the n-e one' do
        board.board[6][5] = described_class.new('white', 6, 5)
        board.board[4][3] = nil
        board.board[3][2] = nil
        board.board[2][1] = nil
        board.board[1][0] = nil
        board.board[4][5] = nil
        board.board[3][6] = nil
        board.board[2][7] = nil
        board.board[6][3] = nil
        board.board[7][2] = nil
        expect(bishop.possible_moves(board.board)).to eq([[4, 3], [3, 2], [2, 1], [1, 0], [6, 3],
                                                          [7, 2], [4, 5], [3, 6], [2, 7]])
      end
    end

    context 'when the n-e diagonal is occupied by an opponent right next to the bishop, the s-e one by an ally one space
    away, the s-w diagonal by an enemy two spaces away and the n-w diagonal by an ally one space away' do
      it 'returns one space to n-e, one space s-e, two spaces s-w and no spaces to n-w' do
        board.board[6][5] = described_class.new('black', 6, 5)
        board.board[4][3] = nil
        board.board[3][2] = described_class.new('black', 3, 2)
        board.board[4][5] = nil
        board.board[3][6] = described_class.new('white', 3, 6)
        board.board[6][3] = described_class.new('white', 6, 3)
        expect(bishop.possible_moves(board.board)).to eq([[4, 3], [3, 2], [6, 5], [4, 5]])
      end
    end
  end
end
