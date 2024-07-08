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
end
