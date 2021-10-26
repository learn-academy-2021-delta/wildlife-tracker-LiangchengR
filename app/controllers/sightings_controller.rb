class SightingsController < ApplicationController
    # def index
    #     sightings = Sighting.all
    #     render json: sightings
    # end

    def index
        sightings = Sighting.where(date: params[:start_date]..params[:end_date])
        render json: sightings
    end

    def show
        sighting = Sighting.find(params[:id])
        render json: sighting
    end

    def update
        sighting = Sighting.find(params[:id])
        sighting.update(sighting_params)
        if sighting.valid?
            render json: sighting
        else
            render json: sighting.errors
        end
    end

    def destroy
        sighting = Sighting.find(params[:id])
        sighting.destroy
        if sighting.valid?
            render json: sighting
        else
            render json: sighting.errors
        end
    end

    private
    def sighting_params
        params.require(:sighting).permit(:animal_id, :latitude, :longitude, :start_date, :end_date)
    end
end
