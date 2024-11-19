require "httparty"

class WeatherService
  include HTTParty
  # HTTParty's base uri is a method
  base_uri "https://api.open-meteo.com"

  def self.get_historical_weather(location, start_date, end_date)
    query = {
      latitude: location[:latitude],
      longitude: location[:longitude],
      start_date: start_date,
      end_date: end_date,
      daily: "temperature_2m_max,temperature_2m_min,precipitation_probability_max"
    }
    response = get("/v1/forecast", query: query)
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
