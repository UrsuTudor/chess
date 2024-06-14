require './lib/pawn'
require './lib/board'

describe Pawn do
  subject(:white_pawn) { described_class.new('white', 1, 1) }
  subject(:black_pawn) { described_class.new('black', 6, 1) }
  let(:board) { Board.new }

  describe 'valid_one_forward_white' do
    it 'returns 2, 0 if the pawn belongs to white and the space ahead if empty' do
      expect(white_pawn.valid_one_forward_white(board.board)).to eq([2, 1])
    end

    it 'returns nil if the pawn belongs to white and there is an allied piece ahead' do
      board.board[2][1] = Pawn.new('white', 2, 1)
      expect(white_pawn.valid_one_forward_white(board.board)).to eq(nil)
    end
  end

  describe 'valid_one_forward_black' do
    it 'returns nil if the pawn belongs to black and there is an allied piece ahead' do
      board.board[5][1] = Pawn.new('black', 5, 1)
      expect(black_pawn.valid_one_forward_black(board.board)).to eq(nil)
    end
  end

  describe 'valid_double_forward_white' do
    it 'returns 3, 0 if the pawn belongs to white' do
      expect(white_pawn.valid_doulbe_forward_white(board.board)).to eq([3, 1])
    end
  end

  describe 'valid_double_forward_black' do
    it 'returns 4, 0 if the pawn belongs to black' do
      expect(black_pawn.valid_doulbe_forward_black(board.board)).to eq([4, 1])
    end

    it 'returns nil if the space ahead is blocked by an allied piece' do
      board.board[5][1] = Pawn.new('black', 5, 1)
      expect(black_pawn.valid_doulbe_forward_black(board.board)).to eq(nil)
    end

    it 'returns nil if the coordinates that are two spaces ahead are blocked by an allied piece' do
      board.board[4][1] = Pawn.new('black', 4, 1)
      expect(black_pawn.valid_doulbe_forward_black(board.board)).to eq(nil)
    end
  end

  describe 'valid_takes_white' do
    it 'returns an empty array if the pawn on [1][1] belongs to white and the right diagonal is empty' do
      expect(white_pawn.valid_takes_white(board.board)).to eq([])
    end

    it 'returns 2, 2 if the pawn on [1][1] belongs to white and there is a black pawn on the right diagonal' do
      board.board[2][2] = Pawn.new('black', 2, 2)
      expect(white_pawn.valid_takes_white(board.board)).to eq([[2, 2]])
    end

    it 'returns an array containing [2, 2] and [2, 0] if the pawn on [1][1] belongs to white and there are black pawns
    on both diagonals' do
      board.board[2][2] = Pawn.new('black', 2, 2)
      board.board[2][0] = Pawn.new('black', 2, 0)
      expect(white_pawn.valid_takes_white(board.board)).to eq([[2, 2], [2, 0]])
    end

    it 'returns an empty array if the pawn on [1][1] belongs to white and the diagonals are occupied by allied pieces' do
      board.board[2][2] = Pawn.new('white', 2, 2)
      board.board[2][0] = Pawn.new('white', 2, 0)
      expect(white_pawn.valid_takes_white(board.board)).to eq([])
    end

    it 'returns 2, 2 if the pawn on [1][1] belongs to white, the left diagonal belongs to an ally and the right one to 
    black' do
      board.board[2][2] = Pawn.new('black', 2, 2)
      board.board[2][0] = Pawn.new('white', 2, 0)
      expect(white_pawn.valid_takes_white(board.board)).to eq([[2, 2]])
    end
  end

  describe 'valid_takes_black' do
    it 'returns an empty array if the pawn on [6][1] belongs to black and the right diagonal is empty' do
      expect(black_pawn.valid_takes_black(board.board)).to eq([])
    end

    it 'returns 5, 2 if the pawn on [6][1] belongs to black and there is a white pawn on the right diagonal' do
      board.board[5][2] = Pawn.new('white', 5, 2)
      expect(black_pawn.valid_takes_black(board.board)).to eq([[5, 2]])
    end

    it 'returns an array containing [5, 2] and [5, 0] if the pawn on [6][1] belongs to black and there are white pawns
    on both diagonals' do
      board.board[5][2] = Pawn.new('white', 5, 2)
      board.board[5][0] = Pawn.new('white', 5, 0)
      expect(black_pawn.valid_takes_black(board.board)).to eq([[5, 2], [5, 0]])
    end

    it 'returns an empty array if the pawn on [6][1] belongs to black and the diagonals are occupied by allied pieces' do
      board.board[5][2] = Pawn.new('black', 5, 2)
      board.board[5][0] = Pawn.new('black', 5, 0)
      expect(black_pawn.valid_takes_black(board.board)).to eq([])
    end

    it 'returns 5, 2 if the pawn on [6][1] belongs to black, the left diagonal belongs to an ally and the right one to
    white' do
      board.board[5][2] = Pawn.new('white', 2, 2)
      board.board[5][0] = Pawn.new('black', 2, 0)
      expect(black_pawn.valid_takes_black(board.board)).to eq([[5, 2]])
    end
  end

  describe 'possible_moves' do
    it 'returns an array containing [2,1], [3,1], [2, 2] if the pawn has no yet moved and it has an enemy on its right diagonal' do
      board.board[2][2] = Pawn.new('black', 2, 2)
      expect(white_pawn.possible_moves(board.board)).to eq([[2, 1], [3, 1], [2, 2]])
    end

    it 'returns an array containing [2,1], [2, 2] if the pawn has no yet moved and it has an enemy on its right diagonal' do
      board.board[2][2] = Pawn.new('black', 2, 2)
      white_pawn.has_moved = true
      expect(white_pawn.possible_moves(board.board)).to eq([[2, 1], [2, 2]])
    end

    it 'returns an array containing [2,1], [3,1], [[2, 2], [2, 0]] if the pawn has no yet moved and it has an enemy on its right diagonal' do
      board.board[2][2] = Pawn.new('black', 2, 2)
      board.board[2][0] = Pawn.new('black', 2, 0)
      expect(white_pawn.possible_moves(board.board)).to eq([[2, 1], [3, 1], [2, 2], [2, 0]])
    end
  end
end
