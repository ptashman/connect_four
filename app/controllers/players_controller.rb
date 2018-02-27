class PlayersController < ApplicationController

  # GET /players
  # GET /players.json
  def index
    @winning_player_name = if player.has_won?
      "You"
    elsif computer_player.has_won?
      "The computer"
    else
      nil
    end
    set_spaces
  end

  # POST /players/move
  def move
    player.move(params[:column])
    column_for_computer = computer_player.column_for_computer(player)
    computer_player.move(column_for_computer)
    redirect_back(fallback_location: root_path)
  end

  private

    def player
      Player.find_by_number_and_computer(1, false)
    end

    def computer_player
      Player.find_by_number_and_computer(2, true)
    end

    def set_spaces
      @spaces = Space.all
      @row_arr = (1..6).to_a.reverse
    end
end
