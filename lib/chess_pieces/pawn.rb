# frozen_string_literal: true

class Pawn
  attr_reader :symbol, :team

  def initialize(team)
    @team = team
    @symbol = @team == 'white' ? "\u2659" : "\u265F"
    @in_play = true
  end
end
