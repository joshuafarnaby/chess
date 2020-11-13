# frozen_string_literal: true

class Rook
  attr_reader :name, :team, :symbol

  def initialize(team)
    @name = 'rook'
    @team = team
    @symbol = @team == 'white' ? "\u2656" : "\u265C"
    @in_play = true
  end
end
