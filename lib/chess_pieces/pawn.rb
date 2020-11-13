# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'

class Pawn
  include Convertable

  attr_reader :name, :team, :symbol

  def initialize(team)
    @name = 'pawn'
    @team = team
    @symbol = @team == 'white' ? "\u2659" : "\u265F"
    @moves_made = 0
    @in_play = true
  end

  def can_make_move?(start_pos, end_pos, curr_player)
    start_index = convert_filerank_to_index(start_pos.position)
    end_index = convert_filerank_to_index(end_pos.position)

    p start_index
    p end_index
    p curr_player

    return false if start_index[1] != end_index[1]

    if @moves_made < 1
      if curr_player == 'white'
        start_index[0] - end_index[0] < 3
      else
        end_index[0] - start_index[0] < 3
      end
    else
      if curr_player == 'white'
        start_index[0] - end_index[0] == 1
      else
        end_index[0] - start_index[0] == 1
      end
    end
  end
end
