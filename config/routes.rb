Rails.application.routes.draw do
  root 'home#index'

  namespace :v1 do
    resources :forecasts, only: [] do
      collection do
        post 'fetch_forecast', to: 'forecasts#fetch_forecast'
      end
    end
  end
end
