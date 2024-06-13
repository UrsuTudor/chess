require './lib/pawn'

describe Pawn do
  subject(:white_pawn) { described_class.new('white', [1, 0]) }
  subject(:black_pawn) { described_class.new('black', [6, 0]) }

  describe 'valid_one_forward' do
    it 'returns 2, 0 if the pawn belongs to white' do
      expect(white_pawn.valid_one_forward).to eq([2, 0])
    end

    it 'returns 5, 0 if the pawn belongs to black' do
      expect(black_pawn.valid_one_forward).to eq([5, 0])
    end
  end

  describe 'valid_double_forward' do
    it 'returns 3, 0 if the pawn belongs to white' do
      expect(white_pawn.valid_doulbe_forward).to eq([3, 0])
    end

    it 'returns 4, 0 if the pawn belongs to black' do
      expect(black_pawn.valid_doulbe_forward).to eq([4, 0])
    end
  end
end
