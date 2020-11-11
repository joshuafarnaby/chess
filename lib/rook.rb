# frozen_string_literal: true

class Rook
  attr_reader :symbol

  def initialize(team)
    @team = team
    @symbol = @team == 'white' ? "\u2656" : "\u265C"
    @in_play = true
  end
end
