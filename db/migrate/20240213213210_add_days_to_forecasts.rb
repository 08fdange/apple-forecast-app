class AddDaysToForecasts < ActiveRecord::Migration[7.1]
  def change
    add_column :forecasts, :days, :integer
  end
end
