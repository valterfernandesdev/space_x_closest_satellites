# frozen_string_literal: true

class SatellitesController < ApplicationController
  def index
    result = Spacex::ClosestSatellites.call(
      latitude: satellites_params[:latitude].to_f,
      longitude: satellites_params[:longitude].to_f,
      number_of_satellites: satellites_params[:number_of_satellites].to_i
    )

    if result.success?
      render json: result.data
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  private

  def satellites_params
    params.permit(:latitude, :longitude, :number_of_satellites)
  end
end
