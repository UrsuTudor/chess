require './lib/rook'
require './lib/board'

describe Rook do
  subject(:rook) { described_class.new('white', 4, 3) }
  let(:board) { Board.new }

  describe 'valid_horizontal' do
    context 'when horizontal is empty' do
      it 'returns the whole horizontal except the space where the rook is in' do
        expect(rook.valid_horizontal(board.board)).to eq([[4, 2], [4, 1], [4, 0], [4, 4], [4, 5], [4, 6], [4, 7]])
      end
    end

    context 'when there is an allied piece to the right' do
      it 'returns only the left horizontal' do
        board.board[4][4] = Rook.new('white', 4, 4)
        expect(rook.valid_horizontal(board.board)).to eq([[4, 2], [4, 1], [4, 0]])
      end
    end

    context 'when there is an opponent piece to the right' do
      it 'returns the left horizontal and one space to the right' do
        board.board[4][4] = Rook.new('black', 4, 4)
        expect(rook.valid_horizontal(board.board)).to eq([[4, 2], [4, 1], [4, 0], [4, 4]])
      end
    end

    context 'when there is an allied piece to the left' do
      it 'returns only the right horizontal' do
        board.board[4][2] = Rook.new('white', 4, 2)
        expect(rook.valid_horizontal(board.board)).to eq([[4, 4], [4, 5], [4, 6], [4, 7]])
      end
    end

    context 'when there is an opponent piece to the left' do
      it 'returns the right horizontal and one space to the left' do
        board.board[4][2] = Rook.new('black', 4, 2)
        expect(rook.valid_horizontal(board.board)).to eq([[4, 2], [4, 4], [4, 5], [4, 6], [4, 7]])
      end
    end

    context 'when there are allied pieces on both sides, two spaces away from the rook' do
      it 'returns the right horizontal and one space to the left' do
        board.board[4][1] = Rook.new('white', 4, 1)
        board.board[4][5] = Rook.new('white', 4, 5)
        expect(rook.valid_horizontal(board.board)).to eq([[4, 2], [4, 4]])
      end
    end

    context 'when there are is an allied piece 3 spaces to the right and an opponent piece 2 spaces to the left' do
      it 'returns the right horizontal and one space to the left' do
        board.board[4][6] = Rook.new('white', 4, 6)
        board.board[4][1] = Rook.new('black', 4, 1)
        expect(rook.valid_horizontal(board.board)).to eq([[4, 2], [4, 1], [4, 4], [4, 5]])
      end
    end
  end

  describe 'valid_vertical' do
    context 'when the vertical is empty' do
      it 'returns the whole vertical ' do
        board.board[1][3] = nil
        board.board[0][3] = nil
        board.board[6][3] = nil
        board.board[7][3] = nil
        expect(rook.valid_vertical(board.board)).to eq([[3, 3], [2, 3], [1, 3], [0, 3], [5, 3], [6, 3], [7, 3]])
      end
    end

    context 'when the downward vertical is empty and there is an allied piece two steps up' do
      it 'returns the entire lower vertical and one space upward' do
        board.board[1][3] = nil
        board.board[0][3] = nil
        board.board[6][3] = Rook.new('white', 6, 3)
        expect(rook.valid_vertical(board.board)).to eq([[3, 3], [2, 3], [1, 3], [0, 3], [5, 3]])
      end
    end

    context 'when the upward vertical is empty and there is an allied piece two steps down' do
      it 'returns the entire upper vertical and one space downward' do
        board.board[6][3] = nil
        board.board[7][3] = nil
        board.board[2][3] = Rook.new('white', 1, 3)
        expect(rook.valid_vertical(board.board)).to eq([[3, 3], [5, 3], [6, 3], [7, 3]])
      end
    end

    context 'when the verticals are occupied by allies' do
      it 'returns an empty array' do
        board.board[3][3] = Rook.new('white', 3, 3)
        board.board[5][3] = Rook.new('white', 5, 3)
        expect(rook.valid_vertical(board.board)).to eq([])
      end
    end

    context 'when there is an opponent piece upward and an allied piece one step down' do
      it 'returns the space with the opponent piece and on space downward' do
        board.board[2][3] = Rook.new('white', 2, 3)
        board.board[5][3] = Rook.new('black', 5, 3)
        expect(rook.valid_vertical(board.board)).to eq([[3, 3], [5, 3]])
      end
    end
  end
end
