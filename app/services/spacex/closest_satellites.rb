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

      errors << 'Latitude invalid' unless latitude.is_a?(Numeric)
      errors << 'Longitude invalid' unless longitude.is_a?(Numeric)
      errors << 'Number of satellites invalid' unless valid_number_of_satellites_param?
      
      raise ClosestSatellitesError, errors.join(', ') if errors.any?
    end

    def valid_number_of_satellites_param?
      number_of_satellites.is_a?(Numeric) && number_of_satellites.positive?
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
              satellite['latitude'],
              satellite['longitude']
            ],
            [
              latitude,
              longitude
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
