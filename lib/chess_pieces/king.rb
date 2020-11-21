# frozen_string_literal: true

class King
  attr_reader :name, :color, :symbol

  def initialize(color)
    @name = 'king'
    @color = color
    @symbol = @color == 'white' ? "\u2654" : "\u265A"
    @in_play = true
  end
end
