module WeatherDataProcessor
  extend ActiveSupport::Concern

  class_methods do
    def process_weather_data(data)
      {
        location: {
          name: data.dig("location", "name"),
          region: data.dig("location", "region"),
          country: data.dig("location", "country")
        },
        current: {
          temp_f: data.dig("current", "temp_f"),
          condition: {
            text: data.dig("current", "condition", "text"),
            icon: data.dig("current", "condition", "icon")
          }
        },
        forecast: {
          forecastday: data["forecast"]["forecastday"].map do |day|
            {
              date: day["date"],
              day: {
                maxtemp_f: day.dig("day", "maxtemp_f"),
                mintemp_f: day.dig("day", "mintemp_f"),
                condition: {
                  text: day.dig("day", "condition", "text"),
                  icon: day.dig("day", "condition", "icon")
                }
              }
            }
          end
        }
      }
    end
  end
end

