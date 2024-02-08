class RemoveUnusedColumnsFromForecasts < ActiveRecord::Migration[7.1]
  def change
    remove_column :forecasts, :address, :string
    remove_column :forecasts, :latitude, :float
    remove_column :forecasts, :longitude, :float
  end
end
