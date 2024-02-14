module V1
  class ForecastsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def fetch_forecast
      zip_code = params[:zip_code]
      days = params[:days].to_i if params[:days].present?
      days ||= 1

      if zip_code.present?
        result = ForecastUpdateService.update_forecast(zip_code, days)
        if result[:success]
          render json: { forecast_data: result[:data], cached: result[:cached] }, status: :ok
        else
          render json: { error: { message: result[:error] || 'Unable to fetch forecast data.' } }, status: :not_found
        end
      else
        render json: { error: { message: 'Zip code is required.' } }, status: :bad_request
      end
    rescue StandardError => e
      render json: { error: { message: "An unexpected error occurred: #{e.message}" } }, status: :internal_server_error
    end
  end
end
