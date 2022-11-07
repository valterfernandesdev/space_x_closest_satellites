# frozen_string_literal: true

module Spacex
  class ClosestSatellites < ApplicationService
    class ClosestSatellitesError < StandardError; end

    attr_reader :latitude, :longitude, :number_of_satellites

    def initialize(latitude:, longitude:, number_of_satellites:)
      @latitude = latitude
      @longitude = longitude
      @number_of_satellites = number_of_satellites
    end

    def call
      validate_params!

      Result.new(success?: true, data: closest_satellites)
    rescue ClosestSatellitesError => e
      Result.new(success?: false, error: e.message)
    end

    private

    def validate_params!
      errors = []

      errors << 'Latitude invalid' unless latitude.between?(-90, 90)
      errors << 'Longitude invalid' unless longitude.between?(-180, 180)
      errors << 'Number of satellites invalid' if number_of_satellites <= 0

      raise ClosestSatellitesError, errors.join(', ') if errors.any?
    end

    def closest_satellites
      map_satellites_distance_to_given_point.sort_by do |satellite|
        satellite['distance_to_given_point_in_km']
      end.first(number_of_satellites)
    end

    def map_satellites_distance_to_given_point
      all_satellites_with_lat_long.map do |satellite|
        {
          'latitude' => satellite['latitude'],
          'longitude' => satellite['longitude'],
          'distance_to_given_point_in_km' => Haversine.distance(
            [
              satellite['latitude'].to_f,
              satellite['longitude'].to_f
            ],
            [
              latitude.to_f,
              longitude.to_f
            ]
          ).to_km.round(2)
        }
      end
    end

    def all_satellites_with_lat_long
      @all_satellites_with_lat_long ||= satellites_with_lat_long(Spacex::StarlinkApi.new.starlinks)
    end

    # Some starlink satellites have nil latitude and/or longitude
    def satellites_with_lat_long(response)
      response.find_all { |satellite| satellite['latitude'].present? && satellite['longitude'].present? }
    end
  end
end
