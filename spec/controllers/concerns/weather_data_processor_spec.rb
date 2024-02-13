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
          "country" => "United States of America",
          "lat"=>40.75,
          "lon"=>-73.99,
          "tz_id"=>"America/New_York",
          "localtime_epoch"=>1707782659,
          "localtime"=>"2024-02-12 19:04",
        },
        "current" => {
          "temp_f" => 66.2,
          "condition" => {
            "text" => "Partly cloudy",
            "icon" => "//cdn.weatherapi.com/weather/64x64/day/116.png"
          },
          "wind_mph"=>4.3,
          "wind_kph"=>6.8,
          "wind_degree"=>50,
          "wind_dir"=>"NE",
          "pressure_mb"=>1012.0,
          "pressure_in"=>29.87,
          "precip_mm"=>0.0,
          "precip_in"=>0.0,
          "humidity"=>53,
          "cloud"=>100,
          "feelslike_c"=>5.6,
          "feelslike_f"=>42.0,
          "vis_km"=>16.0,
          "vis_miles"=>9.0,
          "uv"=>1.0,
          "gust_mph"=>8.1
        },
        "forecast" => {
          "forecastday" => [
            {
              "date" => "2024-02-07",
              "day" => {
                "maxtemp_f" => 68.0,
                "mintemp_f" => 56.3,
                "condition" => {
                  "text" => "Overcast",
                  "icon" => "//cdn.weatherapi.com/weather/64x64/day/113.png"
                },
                "totalprecip_mm"=>0.04,
                "totalprecip_in"=>0.0,
                "totalsnow_cm"=>0.0,
                "avgvis_km"=>10.0,
                "avgvis_miles"=>6.0,
                "avghumidity"=>59
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
                  text: "Overcast",
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
