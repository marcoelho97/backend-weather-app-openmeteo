class WeatherController < ApplicationController
    def historical
      # URL Get parameters
      location = params[:location]
      start_date = params[:start_date]
      end_date = params[:end_date]
  
      # Date range for the multiple records of dates
      weather_data = HistoricalWeather.where(location: location, date: start_date...end_date)
      if weather_data.empty?
        # Fetch data from API
        # TODO: Geocoding to find the coordinates of a location
        coordinates = { latitude: 38.7167, longitude: -9.1333 } # Lisbon
  
        api_response = WeatherService.get_historical_weather(coordinates, start_date, end_date)
  
        if api_response.key?(:error_message)
          render json: api_response
          return
        end
  
        api_response["hourly"]["time"].each_with_index do |hour, index|
          HistoricalWeather.create!(
            location: location,
            date: hour,
            temperature: api_response["hourly"]["temperature_2m"][index],
            precipitation: api_response["hourly"]["precipitation"][index]
          )
        end
  
        weather_data = HistoricalWeather.where(location: location, date: start_date...end_date)
      end
      render json: api_response
    end
  end
  