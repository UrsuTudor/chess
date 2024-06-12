require_relative 'lib/game'

game = Board.new
game.display_board

# create a board class
  # the board should initialize with the pieces in the right position, so I should have a board class to avoid bloating the game class

# will need a class for each piece
  # the piece should know which player it belongs to and what its current position is
    # can create a moveable module for this
  # each class should have a way to get the possible movements and validate the input from the player
    # include a validation method in the moveable module
    # make sure pieces can't move to a space occupied by an ally
  # the pawn will need to know:
    # if this is its first turn or not, so it can move two spaces on its first turn
    # if there is an enemy piece on one of its diagonals, so it can move diagonally
    # if it reached the final square, so it can transform
  # the king will need to know if it's in check/check mate
    # if the king is in check mate, game_over
    # look for possible ties in chess and program those in
      # you need to know what pieces each player has left
      # knowing what pieces each player has taken could also be neat, so you can track score
