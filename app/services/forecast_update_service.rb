class ForecastUpdateService
  include WeatherDataProcessor
  EXPIRATION_IN_SECONDS = 1800

  # Main method to update or fetch the forecast
  def self.update_forecast(zip_code, days)
    redis_key = "forecast:#{zip_code}:days:#{days}"
    result = fetch_from_cache(redis_key)

    unless result[:success] && result[:cached]
      result = fetch_from_database(zip_code, days)
      unless result[:success] && result[:cached]
        result = fetch_and_update(zip_code, redis_key, days)
      end
    end

    result
  end

  private

  # Fetches forecast data from cache
  def self.fetch_from_cache(redis_key)
    cached_forecast = $redis.get(redis_key)
    if cached_forecast
      { success: true, data: JSON.parse(cached_forecast, symbolize_names: true), cached: true }
    else
      { cached: false }
    end
  end

  # Fetches forecast data from the database
  def self.fetch_from_database(zip_code, days)
    forecast = Forecast.find_by(zip_code: zip_code)
    if forecast && !forecast.expired? && forecast.days == days
      $redis.set("forecast:#{zip_code}:days:#{days}", forecast.forecast_data.to_json, ex: EXPIRATION_IN_SECONDS)
      { success: true, data: forecast.forecast_data, cached: true }
    else
      { cached: false }
    end
  end

  # Fetches and updates the forecast data by calling an external service
  def self.fetch_and_update(zip_code, redis_key, days)
    result = WeatherService.fetch_weather(zip_code, days)
    if result[:data].present?
      processed_data = process_weather_data(result[:data])
      update_forecast_record(zip_code, processed_data, days)
      $redis.set(redis_key, processed_data.to_json, ex: EXPIRATION_IN_SECONDS)
      { success: true, data: processed_data, cached: false }
    elsif result[:error].present?
      { success: false, error: result[:error] }
    else
      { success: false, error: 'Unknown error occurred.' }
    end
  end

  # Updates or creates a forecast record in the database
  def self.update_forecast_record(zip_code, forecast_data, days)
    forecast = Forecast.find_or_initialize_by(zip_code: zip_code)
    forecast.forecast_data = forecast_data
    forecast.days = days
    forecast.save!
  end
end
