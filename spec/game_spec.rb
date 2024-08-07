require './lib/game'

# these are outdated tests that were used to test the methods before they were moved into special helpers for the Game
# class
describe Game do
  subject(:game) { described_class.new }
  let(:board) { game.board }

  describe 'lower_diagonal_right_blockable?' do
    let(:checker) { board.board[5][5] }
    let(:king_white) { King.new('white', 4, 4) }

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

    it 'returns true when the path can be blocked by a that has not moved yet' do
      board.board[2][4] = Pawn.new('white', 3, 5)
      expect(game.lower_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end
  end

  describe 'lower_diagonal_left_blockable?' do
    let(:checker) { board.board[6][2] }
    let(:king_white) { King.new('white', 4, 4) }

    before do
      board.board[6][2] = Bishop.new('black', 6, 2)
      board.board[4][4] = king_white
    end

    it 'returns true when the path can be blocked by a knight' do
      board.board[3][4] = Knight.new('white', 4, 5)
      expect(game.lower_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a bishop' do
      board.board[4][2] = Bishop.new('white', 4, 3)
      expect(game.lower_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a rook' do
      board.board[4][3] = Rook.new('white', 5, 4)
      expect(game.lower_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a pawn' do
      board.board[4][3] = Pawn.new('white', 5, 4)
      expect(game.lower_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a that has not moved yet' do
      board.board[3][3] = Pawn.new('white', 4, 4)
      expect(game.lower_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end
  end

  describe 'upper_diagonal_left_blockable?' do
    let(:checker) { board.board[4][4] }
    let(:king_white) { King.new('white', 7, 3) }

    before do
      board.board[4][4] = Bishop.new('black', 4, 4)
      board.board[6][2] = king_white
    end

    it 'returns true when the path can be blocked by a knight' do
      board.board[4][1] = Knight.new('white', 5, 2)
      expect(game.upper_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a bishop' do
      board.board[4][2] = Bishop.new('white', 5, 3)
      expect(game.upper_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a rook' do
      board.board[4][3] = Rook.new('white', 5, 2)
      expect(game.upper_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a that has not moved yet' do
      board.board[3][3] = Pawn.new('white', 4, 4)
      expect(game.upper_diagonal_left_blockable?(checker, king_white)).to eq(true)
    end
  end

  describe 'upper_diagonal_right_blockable?' do
    let(:checker) { board.board[4][0] }
    let(:king_white) { King.new('white', 6, 2) }

    before do
      board.board[4][0] = Bishop.new('black', 4, 0)
      board.board[6][2] = king_white
    end

    it 'returns true when the path can be blocked by a knight' do
      board.board[4][3] = Knight.new('white', 4, 3)
      expect(game.upper_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a bishop' do
      board.board[4][2] = Bishop.new('white', 4, 2)
      expect(game.upper_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a rook' do
      board.board[4][1] = Rook.new('white', 4, 1)
      expect(game.upper_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a that has not moved yet' do
      board.board[3][1] = Pawn.new('white', 3, 1)
      expect(game.upper_diagonal_right_blockable?(checker, king_white)).to eq(true)
    end
  end

  describe 'right_horizontal_blockable?' do
    let(:checker) { board.board[4][0] }
    let(:king_white) { King.new('white', 4, 2) }

    before do
      board.board[4][0] = Rook.new('black', 4, 0)
      board.board[4][2] = king_white
    end

    it 'returns true when the path can be blocked by a knight' do
      board.board[2][2] = Knight.new('white', 2, 2)
      board.display_board
      expect(game.right_horizontal_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a bishop' do
      board.board[2][3] = Bishop.new('white', 2, 3)
      expect(game.right_horizontal_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a rook' do
      board.board[1][1] = Rook.new('white', 1, 1)
      expect(game.right_horizontal_blockable?(checker, king_white)).to eq(true)
    end

    it 'returns true when the path can be blocked by a that has not moved yet' do
      board.board[2][1] = Pawn.new('white', 2, 1)
      expect(game.right_horizontal_blockable?(checker, king_white)).to eq(true)
    end
  end
end
