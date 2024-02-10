class AddIndexToForecastsZipCode < ActiveRecord::Migration[7.1]
  def change
    add_index :forecasts, :zip_code, unique: true
  end
end
