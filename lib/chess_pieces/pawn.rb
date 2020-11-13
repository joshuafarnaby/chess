# frozen_string_literal: true

class Pawn
  attr_reader :name, :team, :symbol

  def initialize(team)
    @name = 'pawn'
    @team = team
    @symbol = @team == 'white' ? "\u2659" : "\u265F"
    @moves_made = 0
    @in_play = true
  end

  def can_make_move?(start_pos, end_pos, curr_player)
    p start_pos
    p end_pos
    p curr_player
  end
end
