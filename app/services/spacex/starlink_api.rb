# frozen_string_literal: true

module Spacex
  class StarlinkApi
    STARTLINK_BASE_URL = 'https://api.spacexdata.com/v4/starlink'

    def starlinks
      response = RestClient.get(STARTLINK_BASE_URL)

      JSON.parse(response.body)
    end
  end
end
