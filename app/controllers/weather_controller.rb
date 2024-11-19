class WeatherController < ApplicationController
    private def count_days(start_date, end_date) 
      ((end_date-start_date).to_i / 60 / 60 / 24 + 1)
    end

    def historical
      # URL Get parameters
      location = params[:location]
      start_date = params[:start_date]
      end_date = params[:end_date]

      parsed_start_date = Date.parse(start_date).beginning_of_day
      parsed_end_date = Date.parse(end_date).end_of_day
  
      # Date range for the multiple records of dates
      weather_data = HistoricalWeather.where(location: location, date: parsed_start_date..parsed_end_date).order(:date)

      # Check if no data on the weather or any date in the range missing
      if weather_data.empty? || count_days(parsed_start_date, parsed_end_date) != weather_data.count
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
  
        weather_response["daily"]["time"].each_with_index do |day, index|

          HistoricalWeather.find_or_create_by(date: day) do |hw|
            hw.location = location
            hw.temperature = (weather_response["daily"]["temperature_2m_max"][index] + weather_response["daily"]["temperature_2m_min"][index]) / 2 # Average temperature
            hw.precipitation = weather_response["daily"]["precipitation_probability_max"][index]
          end

        #   HistoricalWeather.create!(
        #     location: location,
        #     date: day,
        #     temperature: (weather_response["daily"]["temperature_2m_max"][index] + weather_response["daily"]["temperature_2m_min"][index]) / 2, # Average temperature
        #     precipitation: weather_response["daily"]["precipitation_probability_max"][index]
        #   )
        end
  
        weather_data = HistoricalWeather.where(location: location, date: parsed_start_date..parsed_end_date).order(:date)
      end
      render json: weather_data
    end
  end
  