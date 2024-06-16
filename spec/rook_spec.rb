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
end
