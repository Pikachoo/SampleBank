Rails.application.routes.draw do

  root "home#index"

  resources :online_credit, :bank_credit, :credit_payment
  resources :credit_administrate, only: [:index]

  get 'credit_applyment/applyment/:id', to: 'credit_administrate#applyment', as: :applyment
  get 'current_credit/info/:id', to: 'credit_administrate#current_credit', as: :credit_info
  get 'current_credit/close/:id', to: 'credit_administrate#close', as: :credit_close
  get 'credit_applyment/decline/:id', to: 'credit_administrate#applyment_decline', as: :applyment_decline
  get 'credit_applyment/confirmation/:id', to: 'credit_administrate#applyment_confirmation', as: :applyment_confirmation
  get "api/credit_information/:id" => 'credit#get_extra_information_by_id'
end
