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
        location_coordinates_response = GeocodingService.get_location_coordinates(location)

        # Unexpected error
        if location_coordinates_response.key?(:error_message)
          render json: location_coordinates_response
          return
        end

        # Location not found
        if not location_coordinates_response.key?("results")
          render json: {
            error: 400,
            error_message: "Location not found"
          }
          return
        end

        coordinates = {
          latitude: location_coordinates_response["results"][0]["latitude"], 
          longitude: location_coordinates_response["results"][0]["longitude"] 
        }
        
        weather_response = WeatherService.get_historical_weather(coordinates, start_date, end_date)
  
        # Unexpected error
        if weather_response.key?(:error_message)
          render json: weather_response
          return
        end
  
        weather_response["hourly"]["time"].each_with_index do |hour, index|
          HistoricalWeather.create!(
            location: location,
            date: hour,
            temperature: weather_response["hourly"]["temperature_2m"][index],
            precipitation: weather_response["hourly"]["precipitation"][index]
          )
        end
  
        weather_data = HistoricalWeather.where(location: location, date: start_date...end_date)
      end
      render json: weather_data
    end
  end
  