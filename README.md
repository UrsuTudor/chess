# Chess

This is a game of Chess built entirely in Ruby and meant to be played by two people who have access to the same terminal.
The project attempts to adhere to OOP principles, separating responsabilities between classes. Common methods have been moved into parent classes, such as Piece, and modules such as MoveableDiagonally and MoveableInStraightLine.

## Features
- standard chess rules implemented
  * turn handling
  * move validation
  * detection of checks
  * pawn promotion
  * en passant
  * initial two-square pawn advance

- save and load games, with saves going into a "save.json" file
- terminal interface
- unicode chess symbols 

## How to play
1. Clone the repo 
2. Run `ruby chess.rb` to start
3. Follow prompts to play the new game or load a saved file


