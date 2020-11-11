# frozen_string_literal: true

class Queen
  attr_reader :symbol

  def initialize(team)
    @team = team
    @symbol = @team == 'white' ? "\u2655" : "\u265B"
    @in_play = true
  end
end
