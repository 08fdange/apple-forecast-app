require 'faraday'
require 'json'

class WeatherService
  def self.fetch_weather(zip_code)
    api_key = ENV["WEATHER_API_KEY"]
    url = "https://api.weatherapi.com/v1/forecast.json"

    begin
      response = Faraday.get(url, { key: api_key, q: zip_code, days: 1 })

      if response.success?
        JSON.parse(response.body)
      else
        Rails.logger.error "WeatherService fetch_weather error: HTTP #{response.status} - #{response.body}"
        nil
      end
    rescue Faraday::Error => e
      # Handle low-level network errors
      Rails.logger.error "WeatherService fetch_weather connection error: #{e.message}"
      nil
    end
  end
end