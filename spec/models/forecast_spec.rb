require 'rails_helper'

RSpec.describe Forecast, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      forecast = Forecast.new(zip_code: '12345', forecast_data: { "some" => "data" })
      expect(forecast).to be_valid
    end

    it 'is not valid without a zip code' do
      forecast = Forecast.new(forecast_data: { "some" => "data" })
      expect(forecast).to_not be_valid
    end

    it 'is not valid with a duplicate zip code' do
      Forecast.create!(zip_code: '12345', forecast_data: { "some" => "data" })
      forecast = Forecast.new(zip_code: '12345', forecast_data: { "some" => "data" })
      expect(forecast).to_not be_valid
    end
  end

  describe '#expired?' do
    let(:forecast) { Forecast.create!(zip_code: '12345', forecast_data: { "some" => "data" }) }

    it 'returns false for a newly created forecast' do
      expect(forecast.expired?).to eq(false)
    end

    it 'returns true for a forecast created more than 30 minutes ago' do
      forecast.update_column(:updated_at, 31.minutes.ago)
      expect(forecast.expired?).to eq(true)
    end
  end
end
