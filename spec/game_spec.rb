require './lib/game'

describe Game do
  subject(:game) { described_class.new }
  subject(:king_white) { King.new('white', 4, 4) }
  let(:board) { game.board }
  let(:checker) { board.board[5][5] }

  describe 'lower_diagonal_right_blockable?' do
    before do
      board.board[5][5] = Bishop.new('black', 5, 5)
      board.board[3][3] = king_white
    end
    it 'returns true when the path can be blocked by a knight' do
      board.board[3][2] = Knight.new('white', 4, 3)
      expect(game.lower_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a bishop' do
      board.board[3][5] = Bishop.new('white', 4, 6)
      expect(game.lower_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a rook' do
      board.board[3][4] = Rook.new('white', 4, 5)
      expect(game.lower_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a pawn' do
      board.board[3][4] = Pawn.new('white', 4, 5)
      expect(game.lower_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a that has no moved yet' do
      board.board[2][4] = Pawn.new('white', 3, 5)
      expect(game.lower_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end
  end
end
