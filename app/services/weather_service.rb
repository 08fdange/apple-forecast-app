require 'faraday'
require 'json'

class WeatherService
  def self.fetch_weather(zip_code, days = 1)
    api_key = ENV["WEATHER_API_KEY"]
    url = "https://api.weatherapi.com/v1/forecast.json"

    begin
      response = Faraday.get(url, { key: api_key, q: zip_code, days: days })

      if response.success?
        { data: JSON.parse(response.body) }
      else
        begin
          error_details = JSON.parse(response.body)
          error_message = error_details.dig('error', 'message') || "HTTP #{response.status} - Unexpected error"
        rescue JSON::ParserError
          error_message = "HTTP #{response.status} - Error parsing error response"
        end
        
        Rails.logger.error error_message
        { error: "Error fetching weather: #{error_message}" }
      end
    rescue Faraday::Error => e
      error_message = "WeatherService connection error: #{e.message}"
      Rails.logger.error error_message
      { error: error_message }
    end
  end
end

