# frozen_string_literal: true

class Knight
  attr_reader :name, :color, :symbol

  def initialize(color)
    @name = 'knight'
    @color = color
    @symbol = @color == 'white' ? "\u2658" : "\u265E"
    @in_play = true
  end
end
