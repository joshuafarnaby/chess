# frozen_string_literal: true

class Knight
  attr_reader :symbol

  def initialize(team)
    @team = team
    @symbol = @team == 'white' ? "\u2658" : "\u265E"
    @in_play = true
  end
end
