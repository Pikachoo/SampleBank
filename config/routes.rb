Rails.application.routes.draw do

  root "home#index"

  resources :online_credit, :bank_credit, :credit_payment

  get "api/credit_information/:id" => 'credit#get_extra_information_by_id'
end
