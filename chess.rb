require_relative 'lib/game'

game = Game.new
game.play

# will need a class for each piece
  # each class should have a way to get the possible movements and validate the input from the player
    # make sure pieces can't move to a space occupied by an ally
  # the king will need to know if it's in check/check mate
    # if the king is in check mate, game_over
  # make it possible for the king and rook to castle
  # look for possible ties in chess and program those in
    # you need to know what pieces each player has left
    # knowing what pieces each player has taken could also be neat, so you can track score

# look for a way to better handle the situation in which a player accidentaly selects a piece that cannot be moved, like
# selecting a rook on the first round
