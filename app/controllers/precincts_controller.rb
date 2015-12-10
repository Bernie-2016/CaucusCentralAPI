class PrecinctsController < ApplicationController
  before_action :set_precinct, only: [:show, :update, :destroy]

  # GET /precincts
  # GET /precincts.json
  def index
    @precincts = Precinct.all

    render json: @precincts
  end

  # GET /precincts/1
  # GET /precincts/1.json
  def show
    render json: @precinct
  end

  # POST /precincts
  # POST /precincts.json
  def create
    @precinct = Precinct.new(precinct_params)

    if @precinct.save
      render json: @precinct, status: :created, location: @precinct
    else
      render json: @precinct.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /precincts/1
  # PATCH/PUT /precincts/1.json
  def update
    @precinct = Precinct.find(params[:id])

    if @precinct.update(precinct_params)
      render json: @precinct, status: :ok, location: @precinct
    else
      render json: @precinct.errors, status: :unprocessable_entity
    end
  end

  # DELETE /precincts/1
  # DELETE /precincts/1.json
  def destroy
    @precinct.destroy

    head :no_content
  end

  private

    def set_precinct
      @precinct = Precinct.find(params[:id])
    end

    def precinct_params
      params.require(:precinct).permit(:name, :county, :supporting_attendees, :total_attendees)
    end
end
