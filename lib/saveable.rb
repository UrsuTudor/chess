# includes methods that make it possible to save and load the game
module Saveable
  def save_game
    serialized_game = JSON.dump({ board: board.board.each do |row|
      row.each do |col|
        col.to_json
      end
    end,
                                  white_king:,
                                  black_king:,
                                  turn: })

    File.open('save.json', 'w') do |file|
      file.puts serialized_game
    end
  end

  def load_game(game)
    save_file = File.read('save.json')
    data = JSON.parse(save_file)

    game.board.board = load_board(data['board'])

    game.white_king = class_from_json(data['white_king'])
    game.black_king = class_from_json(data['black_king'])
    game.turn = data['turn']
  end

  def load_board(save_data)
    save_data.map do |row|
      row.map do |col|
        class_from_json(col) unless col.nil?
      end
    end
  end
end
