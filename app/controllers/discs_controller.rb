class DiscsController < ApplicationController
  before_action :set_disc, only: [:show, :edit, :update, :destroy]

  # GET /discs
  # GET /discs.json
  def index
    @discs = Disc.all
  end

  # GET /discs/1
  # GET /discs/1.json
  def show
  end

  # GET /discs/new
  def new
    @disc = Disc.new
  end

  # GET /discs/1/edit
  def edit
  end

  # POST /discs
  # POST /discs.json
  def create
    @disc = Disc.new(disc_params)

    respond_to do |format|
      if @disc.save
        format.html { redirect_to @disc, notice: 'Disc was successfully created.' }
        format.json { render :show, status: :created, location: @disc }
      else
        format.html { render :new }
        format.json { render json: @disc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discs/1
  # PATCH/PUT /discs/1.json
  def update
    respond_to do |format|
      if @disc.update(disc_params)
        format.html { redirect_to @disc, notice: 'Disc was successfully updated.' }
        format.json { render :show, status: :ok, location: @disc }
      else
        format.html { render :edit }
        format.json { render json: @disc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discs/1
  # DELETE /discs/1.json
  def destroy
    @disc.destroy
    respond_to do |format|
      format.html { redirect_to discs_url, notice: 'Disc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disc
      @disc = Disc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def disc_params
      params.fetch(:disc, {})
    end
end
