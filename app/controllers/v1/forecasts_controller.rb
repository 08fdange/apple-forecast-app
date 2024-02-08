module V1
  class ForecastsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def fetch_forecast
      zip_code = params[:zip_code]
      if zip_code
        forecast_data, cached = ForecastUpdateService.update_forecast(zip_code)
        if forecast_data.present?
          render json: { forecast_data: forecast_data, cached: cached }, status: :ok
        else
          render json: { error: 'Unable to fetch forecast data.' }, status: :not_found
        end
      else
        render json: { error: 'Unable to resolve address to a zip code.' }, status: :bad_request
      end
    end
  end
end