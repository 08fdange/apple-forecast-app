require 'rails_helper'

RSpec.describe ForecastUpdateService do
  let(:zip_code) { '12345' }
  let(:days) { 10 }
  let(:redis_key) { "forecast:#{zip_code}:days:#{days}" }
  let(:forecast_data) { { current: { temp_f: 70.0 } } }
  let(:serialized_forecast_data) { forecast_data.to_json }

  before do
    allow($redis).to receive(:get).and_return(nil)
    allow($redis).to receive(:set)
    allow(WeatherService).to receive(:fetch_weather).and_return(forecast_data)
    allow(Forecast).to receive(:find_by).and_return(nil)
    allow_any_instance_of(Forecast).to receive(:save!)
    allow(ForecastUpdateService).to receive(:process_weather_data).and_return(forecast_data)
  end

  describe '.update_forecast' do
    context 'when data is not cached' do
      it 'fetches data from the WeatherService and updates the cache' do
        result, cached = ForecastUpdateService.update_forecast(zip_code, days)

        expect(cached).to be false
        expect(result).to eq(forecast_data)
        expect($redis).to have_received(:set).with(redis_key, serialized_forecast_data, ex: ForecastUpdateService::EXPIRATION_IN_SECONDS)
      end
    end

    context 'when data is cached in Redis' do
      before do
        allow($redis).to receive(:get).with(redis_key).and_return(serialized_forecast_data)
      end

      it 'returns data from the cache without hitting the WeatherService' do
        result, cached = ForecastUpdateService.update_forecast(zip_code, days)

        expect(cached).to be true
        expect(result).to eq(forecast_data)
        expect(WeatherService).not_to have_received(:fetch_weather)
      end
    end

    context 'when data is cached in the database but not in Redis' do
      let(:forecast) { Forecast.new(zip_code: zip_code, forecast_data: forecast_data) }
    
      before do
        allow(Forecast).to receive(:find_by).with(zip_code: zip_code).and_return(forecast)
        allow(forecast).to receive(:expired?).and_return(false)
        allow($redis).to receive(:set).with("forecast:#{zip_code}:days:#{days}", forecast.forecast_data.to_json, ex: ForecastUpdateService::EXPIRATION_IN_SECONDS)
      end
    
      it 'returns data from the database and refreshes the Redis cache' do
        result, cached = ForecastUpdateService.update_forecast(zip_code, days)
    
        expected_result = { "current" => { "temp_f" => 70.0 } }
        expect(result).to eq(expected_result)
    
        expect(cached).to be true
        expect($redis).to have_received(:set).with(redis_key, forecast_data.to_json, ex: ForecastUpdateService::EXPIRATION_IN_SECONDS)
      end
    end

    context 'when a subsequent request with different days is made' do
      let(:new_days) { 3 }
      let(:new_redis_key) { "forecast:#{zip_code}:days:#{new_days}" }
      let(:new_forecast_data) { { current: { temp_f: 75.0 } } }
      let(:new_serialized_forecast_data) { new_forecast_data.to_json }
    
      before do
        allow($redis).to receive(:get).with(redis_key).and_return(serialized_forecast_data)
        allow($redis).to receive(:get).with(new_redis_key).and_return(nil)
        allow(WeatherService).to receive(:fetch_weather).with(zip_code, new_days).and_return(new_forecast_data)
        allow(ForecastUpdateService).to receive(:process_weather_data).with(new_forecast_data).and_return(new_forecast_data)
      end
    
      it 'fetches new data from the WeatherService for the new days and updates the cache' do
        ForecastUpdateService.update_forecast(zip_code, days) # Initial request
        new_result, new_cached = ForecastUpdateService.update_forecast(zip_code, new_days) # Subsequent request with different days
    
        expect(new_cached).to be false
        expect(new_result).to eq(new_forecast_data)
        expect($redis).to have_received(:set).with(new_redis_key, new_serialized_forecast_data, ex: ForecastUpdateService::EXPIRATION_IN_SECONDS)
      end
    end    
  end
end
