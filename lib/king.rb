# frozen_string_literal: true

class King
  attr_reader :symbol

  def initialize(team)
    @team = team
    @symbol = @team == 'white' ? "\u2654" : "\u265A"
    @in_play = true
  end
end
