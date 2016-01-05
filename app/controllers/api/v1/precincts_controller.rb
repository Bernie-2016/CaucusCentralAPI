module Api
  module V1
    class PrecinctsController < ApplicationController
      before_action :set_precinct, only: [:show, :update, :destroy]

      # GET /api/v1/precincts
      # GET /api/v1/precincts.json
      def index
        @precincts = Precinct.all

        render json: @precincts
      end

      # GET /api/v1/precincts/1
      # GET /api/v1/precincts/1.json
      def show
        render json: @precinct
      end

      # POST /api/v1/precincts
      # POST /api/v1/precincts.json
      def create
        @precinct = Precinct.new(precinct_params)

        if @precinct.save
          render json: @precinct, status: :created, location: api_v1_precinct_url(@precinct)
        else
          render json: @precinct.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/precincts/1
      # PATCH/PUT /api/v1/precincts/1.json
      def update
        @precinct = Precinct.find(params[:id])

        if @precinct.update(precinct_params)
          render json: @precinct, status: :ok, location: api_v1_precinct_url(@precinct)
        else
          render json: @precinct.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/precincts/1
      # DELETE /api/v1/precincts/1.json
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
  end
end
