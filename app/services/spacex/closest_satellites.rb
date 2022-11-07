# frozen_string_literal: true

module Spacex
  class ClosestSatellites < ApplicationService
    attr_reader :latitude, :longitude, :number_of_satellites

    def initialize(latitude:, longitude:, number_of_satellites:)
      @latitude = latitude
      @longitude = longitude
      @number_of_satellites = number_of_satellites
    end

    def call
      all_satellites_with_lat_long
    end

    private

    def all_satellites_with_lat_long
      @all_satellites_with_lat_long ||= satellites_with_lat_long(Spacex::StarlinkApi.new.starlinks)
    end

    # Some starlink satellites have nil latitude and/or longitude
    def satellites_with_lat_long(response)
      response.find_all { |satellite| satellite['latitude'].present? && satellite['longitude'].present? }
    end
  end
end
