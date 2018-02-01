Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    member do
      put :disable, to: "users#disable"
      put :enable, to: "users#enable"
    end
  end

  resources :devices
  resources :alerts do
    member do
      put :hide, to: "alerts#hide"
    end
  end

  namespace :api, default: {format: :json} do
    get :ajax_sensor_readings, to: "sensor_readings#ajax"
    resources :devices
    resources :sensor_readings do
      collection do
        post :bulk_upload
      end
    end
    resources :users do
      collection do
        get :current, to: "users#current"
      end
    end
  end

  root to: "dashboard#index"
end
