# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SatellitesController do
  describe 'GET /index' do
    subject(:get_index) { get satellites_path, params: params }

    context 'when params are invalid' do
      let(:params) do
        {
          latitude: 100,
          longitude: -200,
          number_of_satellites: 0
        }
      end
      let(:error_message) { 'Latitude invalid, Longitude invalid, Number of satellites invalid' }

      it 'returns unprocessable_entity status with error message' do
        get_index

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq('error' => error_message)
      end
    end

    context 'when params are valid' do
      before do
        allow(Spacex::StarlinkApi).to receive(:new).and_return(starlink_api)
        allow(starlink_api).to receive(:starlinks).and_return(starlinks_api_response)
      end

      let(:params) do
        {
          latitude: 40.71427,
          longitude: -74.00597,
          number_of_satellites: 2
        }
      end
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

      it 'returns closest satellites to given point' do
        get_index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          [
            {
              'distance_to_given_point_in_km' => 5586.9,
              'latitude' => 51.5074,
              'longitude' => 0.1278
            },
            {
              'distance_to_given_point_in_km' => 8251.6,
              'latitude' => -33.42628,
              'longitude' => -70.56656
            }
          ]
        )
      end
    end
  end
end
