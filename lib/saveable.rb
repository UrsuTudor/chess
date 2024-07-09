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

  def load_game
    save_file = File.read('save.json')
    data = JSON.parse(save_file)

    board.board = load_board(data['board'])

    self.white_king = class_from_json(data['white_king'])
    self.black_king = class_from_json(data['black_king'])
    self.turn = data['turn']
  end

  def load_board(save_data)
    save_data.map do |row|
      row.map do |col|
        class_from_json(col) unless col.nil?
      end
    end
  end

  def save_or_load?(player_action)
    if player_action == 'save'
      save_game
      puts "\nYour game was saved!"
      true
    elsif player_action == 'load'
      load_game
      board.display_board
      puts "\nLast save was loaded!"
      true
    end
  end
end
