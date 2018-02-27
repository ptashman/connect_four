class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @winning_player_name = "You" if player.has_won?
    @winning_player_name = "The computer" if computer_player.has_won?
    @winning_player_name ||= nil
    set_spaces
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /players/move
  def move
    player.move(params[:column])
    column_for_computer = computer_player.column_for_computer(player)
    computer_player.move(column_for_computer)
    redirect_back(fallback_location: root_path)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.create(number: 1, computer: false)
    end

    def player
      Player.find_by_number_and_computer(1, false)
    end

    def computer_player
      Player.find_by_number_and_computer(2, true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.fetch(:player, {})
    end

    def set_spaces
      @spaces = Space.all
      @row_arr = (1..6).to_a.reverse
    end
end
