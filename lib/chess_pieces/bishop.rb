# frozen_string_literal: true

class Bishop
  attr_reader :symbol

  def initialize(team)
    @team = team
    @symbol = @team == 'white' ? "\u2657" : "\u265D"
    @in_play = true
  end
end