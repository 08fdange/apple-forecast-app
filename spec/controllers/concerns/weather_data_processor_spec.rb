require 'rails_helper'

class DummyClass
  include WeatherDataProcessor
end

RSpec.describe WeatherDataProcessor, type: :concern do
  describe '.process_weather_data' do
    let(:api_response) do
      {
        "location" => {
          "name" => "New York",
          "region" => "New York",
          "country" => "United States of America"
        },
        "current" => {
          "temp_f" => 66.2,
          "condition" => {
            "text" => "Partly cloudy",
            "icon" => "//cdn.weatherapi.com/weather/64x64/day/116.png"
          }
        },
        "forecast" => {
          "forecastday" => [
            {
              "date" => "2024-02-07",
              "day" => {
                "maxtemp_f" => 68.0,
                "mintemp_f" => 56.3,
                "condition" => {
                  "icon" => "//cdn.weatherapi.com/weather/64x64/day/113.png"
                }
              }
            }
          ]
        }
      }
    end

    let(:expected_result) do
      {
        location: {
          name: "New York",
          region: "New York",
          country: "United States of America"
        },
        current: {
          temp_f: 66.2,
          condition: {
            text: "Partly cloudy",
            icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
          }
        },
        forecast: {
          forecastday: [
            {
              date: "2024-02-07",
              day: {
                maxtemp_f: 68.0,
                mintemp_f: 56.3,
                condition: {
                  icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                }
              }
            }
          ]
        }
      }
    end

    it 'processes the API data and returns a hash with the correct structure' do
      result = DummyClass.process_weather_data(api_response)
      expect(result).to eq(expected_result)
    end
  end
end
