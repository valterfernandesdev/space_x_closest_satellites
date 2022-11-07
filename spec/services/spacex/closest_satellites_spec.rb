# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spacex::ClosestSatellites do
  describe '#call' do
    subject(:call) do
      described_class.new(latitude: latitude, longitude: longitude, number_of_satellites: number_of_satellites).call
    end

    context 'when params are invalid' do
      let(:latitude) { 'invalid' }
      let(:longitude) { nil }
      let(:number_of_satellites) { 0 }

      it 'raises ClosestSatellitesError and returns error message' do
        expect(call).not_to be_success
        expect(call.error).to eq('Latitude invalid, Longitude invalid, Number of satellites invalid')
      end
    end

    context 'when params are valid' do
      before do
        allow(Spacex::StarlinkApi).to receive(:new).and_return(starlink_api)
        allow(starlink_api).to receive(:starlinks).and_return(starlinks_api_response)
      end

      let(:latitude) { 40.71427 }
      let(:longitude) { -74.00597 }
      let(:number_of_satellites) { 2 }
      let(:starlink_api) { instance_double(Spacex::StarlinkApi) }
      let(:starlinks_api_response) do
        [
          {
            'latitude' => -33.42628,
            'longitude' => -70.56656
          },
          {
            'latitude' => 51.5074,
            'longitude' => 0.1278
          },
          {
            'latitude' => 20.71427,
            'other' => 'other'
          }
        ]
      end
      let(:all_starlinks_have_lat_and_long) do
        call.data.all? do |starlink|
          starlink['latitude'].present? && starlink['longitude'].present?
        end
      end

      it 'returns an array of starlinks with latitude and logitude' do
        aggregate_failures do
          expect(call).to be_success
          expect(call.data).to be_an_instance_of(Array)
          expect(call.data.count).to eq(number_of_satellites)
          expect(all_starlinks_have_lat_and_long).to be_truthy
        end
      end

      it 'returns satellites ordered by distance in km to given point' do
        aggregate_failures do
          expect(call.data.first['distance_to_given_point_in_km']).to eq(5586.9)
          expect(call.data.second['distance_to_given_point_in_km']).to eq(8251.6)
        end
      end
    end
  end
end
