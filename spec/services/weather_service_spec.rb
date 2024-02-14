require 'rails_helper'

RSpec.describe WeatherService do
  describe '.fetch_weather' do
    let(:zip_code) { '12345' }
    let(:api_key) { "WEATHER_API_TEST_KEY" }
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

      it 'returns a hash with data key containing the parsed JSON response' do
        result = described_class.fetch_weather(zip_code, days)
        expect(result).to be_a(Hash)
        expect(result[:data]).to include("location" => include("name" => "Some City"))
      end
    end

    context 'when the API call fails with a specific error' do
      let(:params) { { key: api_key, q: zip_code, days: days } }
      let(:status) { 400 }
      let(:error_body) { { "error" => { "code" => 1006, "message" => "No matching location found." } }.to_json }

      before do
        stub_request(:get, url)
          .with(query: params)
          .to_return(status: status, body: error_body, headers: {})
      end

      it 'returns a hash with an error key containing the specific error message' do
        expect(Rails.logger).to receive(:error).with("No matching location found.")
        result = described_class.fetch_weather(zip_code, days)
        expect(result).to be_a(Hash)
        expect(result[:error]).to include("Error fetching weather: No matching location found.")
      end
    end

    context 'when there is a network error' do
      let(:params) { { key: api_key, q: zip_code, days: days } }

      before do
        stub_request(:get, url)
          .with(query: params)
          .to_raise(Faraday::ConnectionFailed.new('connection failed'))
      end

      it 'returns a hash with an error key containing the connection error message' do
        expect(Rails.logger).to receive(:error).with(/WeatherService connection error: connection failed/)
        result = described_class.fetch_weather(zip_code, days)
        expect(result).to be_a(Hash)
        expect(result[:error]).to include("WeatherService connection error: connection failed")
      end
    end    
  end
end