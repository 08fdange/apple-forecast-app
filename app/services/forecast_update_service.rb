class ForecastUpdateService
  include WeatherDataProcessor
  EXPIRATION_IN_SECONDS = 1800

  def self.update_forecast(zip_code, days)
    redis_key = "forecast:#{zip_code}:days:#{days}"
    forecast_data, cached = fetch_from_cache(redis_key)

    unless cached
      forecast_data, cached = fetch_from_database(zip_code)
      unless cached
        forecast_data, cached = fetch_and_update(zip_code, redis_key, days)
      end
    end

    [forecast_data, cached]
  end

  private

  def self.fetch_from_cache(redis_key)
    cached_forecast = $redis.get(redis_key)
    if cached_forecast
      [JSON.parse(cached_forecast, symbolize_names: true), true]
    else
      [nil, false]
    end
  end

  def self.fetch_from_database(zip_code)
    forecast = Forecast.find_by(zip_code: zip_code)
    if forecast && !forecast.expired?
      # Refresh Redis cache as a fallback mechanism
      $redis.set("forecast:#{zip_code}:days:#{days}", forecast.forecast_data.to_json, ex: EXPIRATION_IN_SECONDS)
      [forecast.forecast_data, true]
    else
      [nil, false]
    end
  end

  def self.fetch_and_update(zip_code, redis_key, days)
    fetched_data = WeatherService.fetch_weather(zip_code, days)
    if fetched_data.present?
      processed_data = process_weather_data(fetched_data)
      update_forecast_record(zip_code, processed_data)
      $redis.set(redis_key, processed_data.to_json, ex: EXPIRATION_IN_SECONDS)
      [processed_data, false]
    else
      [nil, false]
    end
  end

  def self.update_forecast_record(zip_code, forecast_data)
    forecast = Forecast.find_or_initialize_by(zip_code: zip_code)
    forecast.forecast_data = forecast_data
    forecast.save!
  end
end
