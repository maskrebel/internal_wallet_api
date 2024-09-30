Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :transactions, only: [:create]
  get 'stocks/price/:ticker', to: 'price_stocks#show', as: :stock_price
  get 'stocks/prices', to: 'price_stocks#index', as: :stocks_prices
  get 'stocks/price_all', to: 'price_stocks#all', as: :all_stocks_prices

  post 'user/login', to: 'user#login', as: :user_login
  post 'user/logout', to: 'user#logout', as: :user_logout
  get 'user/balance', to: 'user#balance', as: :user_balance
  get 'user/history', to: 'user#history', as: :user_history
end
