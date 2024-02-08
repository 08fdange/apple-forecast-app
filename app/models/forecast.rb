class Forecast < ApplicationRecord
  validates :zip_code, presence: true, uniqueness: true

  def expired?
    updated_at < 30.minutes.ago
  end
end
