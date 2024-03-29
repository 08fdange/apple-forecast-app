require 'rails_helper'

RSpec.describe V1::ForecastsController, type: :request do
  describe 'POST #fetch_forecast' do
    let(:zip_code) { '12345' }
    let(:forecast_data) { { "current" => { "temp_f" => 70.0 } } }
    let(:cached) { false }
    let(:default_days) { 1 }

    context 'when a zip code and days parameter are provided' do
      let(:days) { 3 }
      
      before do
        allow(ForecastUpdateService).to receive(:update_forecast).with(zip_code, days)
          .and_return({ success: true, data: forecast_data, cached: cached })
        post "/v1/forecasts/fetch_forecast", params: { zip_code: zip_code, days: days }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns forecast data and cache status for the specified number of days' do
        expect(JSON.parse(response.body)).to eq({ 'forecast_data' => forecast_data, 'cached' => cached })
      end
    end

    context 'when no days parameter is provided' do
      before do
        allow(ForecastUpdateService).to receive(:update_forecast).with(zip_code, default_days)
          .and_return({ success: true, data: forecast_data, cached: cached })
        post "/v1/forecasts/fetch_forecast", params: { zip_code: zip_code }
      end

      it 'returns http success with default days value' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns forecast data and cache status using the default days value' do
        expect(JSON.parse(response.body)).to eq({ 'forecast_data' => forecast_data, 'cached' => cached })
      end
    end

    context 'when no forecast data is found' do
      let(:error_message) { 'Unable to fetch forecast data.' }
      
      before do
        allow(ForecastUpdateService).to receive(:update_forecast).with(zip_code, default_days)
          .and_return({ success: false, error: error_message })
        post "/v1/forecasts/fetch_forecast", params: { zip_code: zip_code }
      end

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => { 'message' => error_message } })
      end
    end

    context 'when no zip code is provided' do
      let(:error_message) { 'Zip code is required.' }

      before do
        post "/v1/forecasts/fetch_forecast", params: { days: default_days }
      end

      it 'returns http bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => { 'message' => error_message } })
      end
    end
  end
end

