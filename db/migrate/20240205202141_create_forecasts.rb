class CreateForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :forecasts do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.jsonb :forecast_data # Change to jsonb for PostgreSQL
      t.string :zip_code     # Add the zip_code column here

      t.timestamps
    end
  end
end