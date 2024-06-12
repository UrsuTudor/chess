require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'

# initializes, remembers and displays the board state
class Board
  def initialize
    @board = Array.new(8) { Array.new(8) }
    place_pawns
    place_rooks
    place_knight
    place_bishop
    place_queen
    place_king
  end

  attr_accessor :board

  def display_board
    puts "\n-----------------------------------------"
    board.each do |row|
      print '|'

      row.each do |col|
        if col.nil?
          print "#{col}    |"

        # for some reason black pawns are bigger than the other pieces and I need a special case to handle them
        elsif col.instance_of?(Pawn) && col.player == 'black'
          print " #{col.black} |" if col.player == 'black'
        else
          print " #{col.white}  |" if col.player == 'white'
          print " #{col.black}  |" if col.player == 'black'
        end
      end

      puts "\n-----------------------------------------"
    end
  end

  private

  def place_pawns
    board[6].map! do |space|
      space = Pawn.new('white')
    end

    board[1].map! do |space|
      space = Pawn.new('black')
    end
  end

  def place_rooks
    board[0][0] = Rook.new('black')
    board[0][7] = Rook.new('black')

    board[7][0] = Rook.new('white')
    board[7][7] = Rook.new('white')
  end

  def place_knight
    board[0][1] = Knight.new('black')
    board[0][6] = Knight.new('black')

    board[7][1] = Knight.new('white')
    board[7][6] = Knight.new('white')
  end

  def place_bishop
    board[0][2] = Bishop.new('black')
    board[0][5] = Bishop.new('black')

    board[7][2] = Bishop.new('white')
    board[7][5] = Bishop.new('white')
  end

  def place_queen
    board[0][3] = Queen.new('black')

    board[7][3] = Queen.new('white')
  end

  def place_king
    board[0][4] = King.new('black')

    board[7][4] = King.new('white')
  end
end
