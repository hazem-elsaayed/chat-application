Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  resources :applications, only: [:index, :show, :update, :create], param: :token do
    resources :chats, only: [:index, :show, :update, :create], param: :number do
      resources :messages, only: [:index, :show, :update, :create], param: :message_number do
        get 'search', on: :collection
      end
    end
  end 

  match '*unmatched', to: 'application#route_not_found', via: :all
end
