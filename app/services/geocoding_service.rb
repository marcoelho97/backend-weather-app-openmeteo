require "httparty"

class GeocodingService
  include HTTParty
  base_uri "https://geocoding-api.open-meteo.com"

  # Will assume the first result is the expected one
  def self.get_location_coordinates(location)
    query = {
      name: location,
      count: 1
    }
    response = get("/v1/search", query: query)
    if response.success?
      response.parsed_response
    else
      {
        error: 500,
        error_message: "Something seems to have happened. Please contact support."
      }
    end
  end
end