# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spacex::ClosestSatellites do
  describe '#call' do
    subject(:call) do
      described_class.new(latitude: latitude, longitude: longitude, number_of_satellites: number_of_satellites).call
    end

    # new york
    let(:latitude) { 40.71427 }
    let(:longitude) { -74.00597 }
    let(:number_of_satellites) { 1 }
    let(:starlink_api) { instance_double(Spacex::StarlinkApi) }
    let(:starlinks_api_response) do
      [
        {
          'latitude' => -33.42628, # santiago chile
          'longitude' => -70.56656 # santiago chile
        },
        {
          'latitude' => 51.5074,
          'longitude' => 0.1278
        },
        {
          'latitude' => 20.71427,
          'other' => -44.00597
        }
      ]
    end
    let(:all_starlinks_have_lat_and_long) do
      call.all? do |starlink|
        starlink['latitude'].present? && starlink['longitude'].present?
      end
    end

    before do
      allow(Spacex::StarlinkApi).to receive(:new).and_return(starlink_api)
      allow(starlink_api).to receive(:starlinks).and_return(starlinks_api_response)
    end

    it 'returns an array of starlinks with latitude and logitude' do
      expect(call).to be_an_instance_of(Array)
      expect(call.count).to eq(2)
      expect(all_starlinks_have_lat_and_long).to be_truthy
    end
  end
end
