# frozen_string_literal: true

class Queen
  attr_reader :name, :team, :symbol

  def initialize(team)
    @name = 'queen'
    @team = team
    @symbol = @team == 'white' ? "\u2655" : "\u265B"
    @in_play = true
  end
end
