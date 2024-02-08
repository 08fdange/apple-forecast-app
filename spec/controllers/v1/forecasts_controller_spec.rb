require 'rails_helper'

RSpec.describe V1::ForecastsController, type: :controller do
  describe 'GET #fetch_forecast' do
    let(:zip_code) { '12345' }
    let(:forecast_data) { { "current" => { "temp_f" => 70.0 } } }
    let(:cached) { false }

    context 'when a zip code is provided' do
      before do
        allow(ForecastUpdateService).to receive(:update_forecast).with(zip_code).and_return([forecast_data, cached])
        get :fetch_forecast, params: { zip_code: zip_code }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns forecast data and cache status' do
        expect(JSON.parse(response.body)).to eq({ 'forecast_data' => forecast_data, 'cached' => cached })
      end
    end

    context 'when no forecast data is found' do
      before do
        allow(ForecastUpdateService).to receive(:update_forecast).with(zip_code).and_return([nil, false])
        get :fetch_forecast, params: { zip_code: zip_code }
      end

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Unable to fetch forecast data.' })
      end
    end

    context 'when no zip code is provided' do
      before do
        get :fetch_forecast, params: {}
      end

      it 'returns http bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Unable to resolve address to a zip code.' })
      end
    end
  end
end
