# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spacex::StarlinkApi do
  describe '#starlinks' do
    subject(:starlinks) { described_class.new.starlinks }

    it 'returns an array of starlinks with latitude and logitude' do
      VCR.use_cassette('starlink_api/starlinks') do
        expect(starlinks).to be_an_instance_of(Array)
        expect(starlinks).to be_present
      end
    end
  end
end
