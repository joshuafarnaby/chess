# frozen_string_literal: true

class Knight
  attr_reader :name, :team, :symbol

  def initialize(team)
    @name = 'knight'
    @team = team
    @symbol = @team == 'white' ? "\u2658" : "\u265E"
    @in_play = true
  end
end
