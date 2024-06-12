class Board
  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def display_board
    puts "\n-----------------------------------------"
    @board.each do |row|
      print '|'
      row.each do |col|
        print "#{col}    |"
      end
      puts "\n-----------------------------------------"
    end
  end
end
