require 'json'

# converts pieces to JSON and makes it possible to turn them back into custom objects
module JSONable
  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'player' => player,
      'row' => row,
      'col' => col,
      'white' => white,
      'black' => black
    }.to_json(*args)
  end

  def class_from_json(json_class)
    class_name(json_class).new(json_class['player'], json_class['row'], json_class['col'])
  end

  def class_name(json_class)
    case json_class['json_class']
    when 'Rook'
      Rook
    when 'Knight'
      Knight
    when 'Bishop'
      Bishop
    when 'Queen'
      Queen
    when 'King'
      King
    when 'Pawn'
      Pawn
    end
  end
end
