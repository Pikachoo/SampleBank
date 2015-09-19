Rails.application.routes.draw do

  root "home#index"

  resources :online_credit
end
