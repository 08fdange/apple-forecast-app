require 'rails_helper'

RSpec.describe WeatherService do
  describe '.fetch_weather' do
    let(:zip_code) { '12345' }
    let(:api_key) { 'WEATHER_API_TEST_KEY' }
    let(:url) { "https://api.weatherapi.com/v1/forecast.json" }
    let(:days) { 1 }

    context 'when the API call is successful' do
      let(:params) { { key: api_key, q: zip_code, days: days } }
      let(:status) { 200 }
      let(:body) { { "location" => { "name" => "Some City" }, "forecast" => { "forecastday" => [{}] } }.to_json }

      before do
        stub_request(:get, url)
          .with(query: params)
          .to_return(status: status, body: body, headers: {})
      end

      it 'returns the parsed JSON response' do
        result = described_class.fetch_weather(zip_code, days)
        expect(result).to be_a(Hash)
        expect(result['location']['name']).to eq('Some City')
      end
    end

    context 'when the API call fails' do
      let(:params) { { key: api_key, q: zip_code, days: days } }
      let(:status) { 500 }
      let(:body) { 'Internal Server Error' }

      before do
        stub_request(:get, url)
          .with(query: params)
          .to_return(status: status, body: body, headers: {})
      end

      it 'logs an error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/WeatherService fetch_weather error/)
        result = described_class.fetch_weather(zip_code)
        expect(result).to be_nil
      end
    end

    context 'when there is a network error' do
      let(:params) { { key: api_key, q: zip_code, days: days } }

      before do
        stub_request(:get, url)
          .with(query: params)
          .to_raise(Faraday::ConnectionFailed.new('connection failed'))
      end

      it 'logs an error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/WeatherService fetch_weather connection error/)
        result = described_class.fetch_weather(zip_code)
        expect(result).to be_nil
      end
    end    
  end
end


